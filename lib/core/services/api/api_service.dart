import 'package:pineapp/models/dashboard/cards.dart';
import 'package:pineapp/models/dashboard/notifications.dart';
import 'package:pineapp/models/recon/recon.dart';
import 'package:pineapp/models/recon/recon_scan.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'auth_interceptor.dart';

part '../../../generated/core/services/api/api_service.g.dart';

@RestApi(baseUrl: "http://172.16.42.1:1471")
abstract class ApiService {
  factory ApiService(Dio dio, {required String baseUrl}) {
    dio.interceptors.add(AuthInterceptor());
    return _ApiService(dio, baseUrl: baseUrl);
  }

  // Auth
  @POST("/api/login")
  Future<dynamic> login(@Body() Map<String, dynamic> body);

  @POST("/api/logout")
  Future<dynamic> logout();

  @GET("/api/notifications")
  Future<List<NotificationItem>> getNotifications();

  @DELETE("/api/notifications/{notificationId}")
  Future<dynamic> deleteNotification(
      @Path("notificationId") int notificationId);

  // Dashboard
  @GET("/api/dashboard/cards")
  Future<DashboardCards> getDashboardCards();

  @GET("/api/dashboard/news")
  Future<dynamic> getDashboardNews();

  // PineAP Status
  @GET("/api/pineap/status")
  Future<dynamic> getPineAPStatus();

  @POST("/api/pineap/start")
  Future<dynamic> startPineAP();

  @POST("/api/pineap/stop")
  Future<dynamic> stopPineAP();

  // Recon Functionality
  @POST("/api/recon/start")
  Future<dynamic> startRecon(@Body() Map<String, dynamic> body);

  @POST("/api/recon/stop")
  Future<dynamic> stopRecon();

  // Ajout : Obtenir la liste des scans
  @GET("/api/recon/scans")
  Future<List<ReconScan>> getReconScans();

  // Ajout : Obtenir les résultats d'un scan particulier
  @GET("/api/recon/scans/{scanId}")
  Future<APResults> getReconScanResults(@Path("scanId") int scanId);

  // Add SSID to PineAP Pool
  @PUT("/api/pineap/ssids/ssid")
  Future<dynamic> addSsidToPineAPPool(@Body() Map<String, dynamic> body);

  // Add SSID to Filter
  @PUT("/api/pineap/filters/ssid/list")
  Future<dynamic> addSsidToFilter(@Body() Map<String, dynamic> body);

  // Add Client to Filter
  @PUT("/api/pineap/filters/client/list")
  Future<dynamic> addClientToFilter(@Body() Map<String, dynamic> body);

  // Deauthenticate All Clients
  @POST("/api/pineap/deauth/ap")
  Future<dynamic> deauthAllClients(@Body() Map<String, dynamic> body);

  // Commencer la capture WPA Handshakes
  @POST("/api/pineap/handshakes/start")
  Future<dynamic> startWPAHandshake(@Body() Map<String, dynamic> body);

// Arrêter la capture WPA Handshakes
  @POST("/api/pineap/handshakes/stop")
  Future<dynamic> stopWPAHandshake();

  // Ajout pour récupérer les handshakes capturés
  @GET("/api/pineap/handshakes")
  Future<dynamic> getWPAHandshakes();

  @POST("/api/download")
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> downloadFile(@Body() Map<String, dynamic> body);

  @DELETE("/api/pineap/handshakes/delete")
  Future<dynamic> deleteWPAHandshake(@Body() Map<String, dynamic> body);

  // Obtenir les paramètres PineAP
  @GET("/api/pineap/settings")
  Future<dynamic> getPineAPSettings();

  // Sauvegarder les paramètres PineAP
  @PUT("/api/pineap/settings")
  Future<dynamic> savePineAPSettings(@Body() Map<String, dynamic> body);

  @GET("/api/settings/networking/ap/open")
  Future<dynamic> getOpenAPSettings();

  @PUT("/api/settings/networking/ap/open")
  Future<dynamic> saveOpenAPSettings(@Body() Map<String, dynamic> body);

  @GET("/api/settings/networking/ap/wpa")
  Future<dynamic> getEvilApSettings();

  @PUT("/api/settings/networking/ap/wpa")
  Future<dynamic> saveEvilApSettings(@Body() Map<String, dynamic> body);
}
