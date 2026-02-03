part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const splashScreen = Paths.splashScreen;
  static const homeView = Paths.homeView;
  static const settingView = Paths.settingView;
  static const addNoteView = Paths.addNoteView;
  static const premiumView = Paths.premiumView;
  static const favouriteView = Paths.favouriteView;
  static const generatePostView = Paths.generatePostView;
  static const postCreateView = Paths.postCreateView;
  static const aiToolsView = Paths.aiToolsView;
  static const aiToolsResponseView = Paths.aiToolsResponseView;
  static const aiToolCreateView = Paths.aiToolCreateView;
  static const faqView = Paths.faqView;
}

abstract class Paths {
  static const splashScreen = '/SplashScreen';
  static const homeView = '/homeView';
  static const settingView = '/settingView';
  static const addNoteView = '/addNoteView';
  static const premiumView = '/premiumView';
  static const favouriteView = '/favouriteView';
  static const generatePostView = '/generatePostView';
  static const postCreateView = '/postCreateView';
  static const aiToolsView = '/aiToolsView';
  static const aiToolsResponseView = '/aiToolsResponseView';
  static const aiToolCreateView = '/aiToolCreateView';
  static const faqView = '/faqView';
}
