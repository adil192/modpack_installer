abstract class Downloader {

  Uri? get modpackUrl;
  bool get isDownloading => modpackUrl != null;
  
}