import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/storyPage/listening/cubit.dart';
import 'package:readr_app/blocs/storyPage/listening/states.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/dateTimeFormat.dart';
import 'package:readr_app/models/listening.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/widgets/mMAdBanner.dart';
import 'package:readr_app/widgets/youtubeWidget.dart';

class ListeningWidget extends StatefulWidget {
  const ListeningWidget({key}) : super(key: key);

  @override
  _ListeningWidget createState() {
    return _ListeningWidget();
  }
}

class _ListeningWidget extends State<ListeningWidget> {
  @override
  void initState() {
    _fetchListeningStoryPageInfo(context.read<ListeningStoryCubit>().storySlug);
    super.initState();
  }

  _fetchListeningStoryPageInfo(String storySlug) {
    context.read<ListeningStoryCubit>().fetchListeningStoryPageInfo(storySlug);
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return BlocBuilder<ListeningStoryCubit, ListeningStoryState>(
      builder: (context, state) {
        if (state is ListeningStoryError) {
          final error = state.error;
          print('StoryError: ${error.message}');
          return Container();
        }

        if(state is ListeningStoryLoaded) {
          Listening listening = state.listening;
          RecordList recordList = state.recordList;

          return _buildListeningStoryWidget(
            width,
            listening,
            recordList,
          );
        }

        // state is Init, Loading
        return _loadingWidget();
      }
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator(),);
  }

  Widget _buildListeningStoryWidget(
    double width,
    Listening listening,
    RecordList recordList,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView(children: [
            YoutubeWidget(
              width: width,
              youtubeId: listening.slug,
            ),
            SizedBox(height: 16.0),
            if(isListeningWidgetAdsActivated)
            ...[
              MMAdBanner(
                adUnitId: listening.storyAd.hDUnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
              SizedBox(height: 16),
            ],
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: _buildTitleAndDescription(listening),
            ),
            SizedBox(height: 16.0),
            if(isListeningWidgetAdsActivated)
            ...[
              MMAdBanner(
                adUnitId: listening.storyAd.aT1UnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
              SizedBox(height: 16),
            ],
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: _buildTheNewestVideos(width, recordList),
            ),
            if(isListeningWidgetAdsActivated)
            ...[
              MMAdBanner(
                adUnitId: listening.storyAd.fTUnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
              SizedBox(height: 16),
            ],
          ]),
        ),
        if(isListeningWidgetAdsActivated)
          MMAdBanner(
            adUnitId: listening.storyAd.stUnitId,
            adSize: AdSize.banner,
            isKeepAlive: true,
          ),
      ],
    );
  }

  _buildTitleAndDescription(Listening listening) {
    DateTimeFormat dateTimeFormat = DateTimeFormat();

    return Column(
      children: [
        Text(
          listening.title,
          style: TextStyle(
            fontSize: 28,
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Text(
              dateTimeFormat.changeYoutubeStringToDisplayString(
                  listening.publishedAt, 'yyyy/MM/dd HH:mm:ss'),
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          listening.description.split('-----')[0],
          style: TextStyle(
            fontSize: 20,
            height: 1.8,
          ),
        ),
      ],
    );
  }

  _buildTheNewestVideos(double width, RecordList recordList) {
    double imageWidth = width - 32;
    double imageHeight = width / 16 * 9;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '最新影音',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: appColor,
          ),
        ),
        SizedBox(height: 16,),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recordList.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: Column(
                  children: [
                    CachedNetworkImage(
                      height: imageHeight,
                      width: imageWidth,
                      imageUrl: recordList[index].photoUrl,
                      placeholder: (context, url) => Container(
                        height: imageHeight,
                        width: imageWidth,
                        color: Colors.grey,
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: imageHeight,
                        width: imageWidth,
                        color: Colors.grey,
                        child: Icon(Icons.error),
                      ),
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      recordList[index].title,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                onTap: () {
                  _fetchListeningStoryPageInfo(recordList[index].slug);
                },
              );
            }),
      ],
    );
  }
}
