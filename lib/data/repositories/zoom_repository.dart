import 'package:zoom_allinonesdk/constants/zoom_constants.dart';
import 'package:zoom_allinonesdk/data/models/accesstokenmodel.dart';

import '../providers/zoom_provider.dart';

class ZoomRepository {
  ZoomProvider zoomProvider;
  ZoomRepository({required this.zoomProvider});

  Future<AccessTokenModel> fetchAccesstoken(
      {required String clientId,
      required String clientSecret,
      required String accountId}) async {
    try {
      final response = await zoomProvider.getAccessToken(
          clientId: clientId, clientSecret: clientSecret, accountId: accountId);
      if (response.statusCode == 200) {
        AccessTokenModel data = AccessTokenModel.fromJson(response.data);

        return data;
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<String> fetchZaktoken(
      {required String clientId,
      required String clientSecret,
      required String accessToken}) async {
    try {
      final response = await zoomProvider.getZAKToken(
          clientId: clientId,
          clientSecret: clientSecret,
          accessToken: accessToken);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        if (responseData.keys.contains(ZoomConstants.TOKEN)) {
          return responseData[ZoomConstants.TOKEN];
        } else {
          return "";
        }
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
