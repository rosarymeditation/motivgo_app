import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../model/language_model.dart';

class AppConstant {
  // https://rosary-api.onrender.com/api/

  //static const String BASE_URL = "https://motivgo-api.onrender.com/api/";
  // static const String BASE_URL =
  // "https://catholic-dating-server.onrender.com/api/";
  static const String BASE_URL = "http://localhost:8001/api/";

  //
  //occupationList
  static String offerings = Platform.isAndroid ? "deafult" : "ios_offering";
  static String entitltment = Platform.isAndroid ? "premium" : "ios_pro";

  static const String DETECT_FACE_URL = "detect-face";
  static const String USER_PROFILE_KEY = "user_profile_key";
  static const String NIGERIA = "Nigeria";
  static const String REGISTRATION_URL_KEY = "registration_url_key";
  static const String ABROAD = "Abroad";
  static const String ENTILEMENT_ID = "premium";
  static const String PRIMARY_COLOR_CACHE = "primary_color_cache";
  static const String ALL_FEED_URL = "allFeeds";
  static const String AUDIOS_URL = "audios";
  static const String REGISTRATION_URL = "sign-up";
  static const String REQUEST_PASSWORD_RESET_URL = "requestPasswordReset";
  static const String RESET_PASSWORD_URL = "resetPassword";
  static const String GET_ACCESS_CODE = "getAccessCode";
  static const String UPDATE_PROFILE_PHOTO = "updateProfilePhoto";
  static const String UPDATE_HOBBIES = "updateHobbies";
//updateHobbies
  static const String IS_SUBSCRIBED_KEY = "is_subscribed_key";
  static const String LIKE_FEED_URL = "likeFeed";
  static const String DELETE_USER_URL = "deleteUser";
  static const String GET_PROFILE_DATA = "find-Profile-Data";
  static const String GET_USER_FEEDS = "findFeedByUser";
  static const String GET_ALL_FEEDS = "findAllFeed";
  static const String ARE_USER_MATCHED = "areUsersMatched";
  //areUsersMatched
  static const String DELETE_FEED = "deleteFeed";
  static const String TOGGLE_LIKE = "toggleLike";
  static const String ADD_COMMENT = "addComment";
  static const String GET_REFERAL_COUNT = "getReferralCount";
  static const String PARTICIPATE_DRAW = "participateInDraw";
  static const String GET_CURRENT_DRAW = "getCurrentDraw";
  static const String CHECK_IF_USER_PARTICIPATED_IN_DRAW = "checkParticipation";
  //checkParticipation
  static const String IS_MUTED_CACHE = "isMuted";
  static const String SONG_URL_CACHE = "song_url";
  static const String UPGRADE_URL = "upgradeToPremium";
  static const String UNVERIFIED = "Unverified";
  static const String APPROVED = "Approved";
  static const String PENDING = "Pending";
  static const String REJECTED = "Rejected";

  static const String SEND_EMAIL_OTP_URL = "sendEmailOtp";
  static const String VERIFY_EMAIL_OTP_URL = "verifyEmailOtp";
  static const String CHECK_EMAIL_EXIST_URL = "checkEmailExist";
  static const String RESEND_EMAIL_OTP_URL = "resendEmailOtp";
//resendEmailOtp
  static const String DEFAULT_LOGO = "assets/icon/icon.png";

  static const String DEFAULT_AVATAR = "assets/images/avatar.jpg";
  static const String DEFAULT_AVATAR_ONLINE =
      "https://foodengo2.s3.eu-west-2.amazonaws.com/rosary/avatar.jpg";
  static const String APP_NAME = "IgboCrush";
  static const DEFAULT_BANNER =
      "https://rosaryapp.s3.eu-west-2.amazonaws.com/banner.jpg";
  static const String SIGN_IN = "Sign In";
  static const String SIGN_UP = "Sign Up";
  static const String SCREEN_SLEEP_MUSIC = "sleep_music";
  static const String SCREEN_ROSARY = "rosary";
  static const String SCREEN_SONGS = "songs";
  static const String OCCUPATION_LIST = "occupationList";

  static const String USER_PROFILE = "Profile";
  static const int START_ROSARY = -2;
  static const int PAGE_LIMIT = 20;
  static const int APOSTLE = -1;
  static const int PERCENTAGE_MATCH_THRESHOLD = 65;
  static const String FEEDBACK_URL = "contact-us";
  static const String GET_USER_MATCHES_NEW_URL = "getUserMatches";
  //getUserMatches

  static const String SUBSCRIPTION_ID = "subscriptionId";

  static const String TOKEN = "login_token";
  static const String USER_ID = "user-id";

  static const String RESPONSE = "Response";
  static const String IMG_PATH = "assets/images/";
  static const String PAYPAL_LINK = "https://www.paypal.me/rosaryMG";
  //https://www.paypal.me/rosaryMG
  static const String COUNTRY_CODE = "country_code";
  static const String REFLECTION_KEY = "reflection_key";
  static const String LANGUAGE_CODE = "language_code";
  //addProfileView
  static const String ODOGWU = "Odogwu";
  static const String ACHALUGO = "Achalugo";
  static const String MALE = "Male";
  static const String FEMALE = "Female";

  static int generate12DigitRandomNumber(Random random) {
    int min = 100000000; // 12-digit minimum
    int max = 999999999; // 12-digit maximum
    return min + random.nextInt(max - min + 1);
  }
static String formatGoalTime(DateTime goalDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final goalDay = DateTime(goalDate.year, goalDate.month, goalDate.day);

    String dayLabel;
    if (goalDay == today) {
      dayLabel = "Today";
    } else if (goalDay == tomorrow) {
      dayLabel = "Tomorrow";
    } else {
      dayLabel = "${goalDate.day}/${goalDate.month}";
    }

    // Format time as HH:mm (24-hour)
    final timeLabel =
        "${goalDate.hour.toString().padLeft(2, '0')}:${goalDate.minute.toString().padLeft(2, '0')}";

    return "$dayLabel · $timeLabel";
  }
  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: "us.jpeg",
        languageCode: "en",
        countryCode: "US",
        languageName: "English"),
    LanguageModel(
        imageUrl: "spain.webp",
        languageCode: "es",
        countryCode: "ES",
        languageName: "Español"),
  ];



  static String getImagePath(String name) {
    return "assets/images/$name";
  }

  static bool hasUnderscore(text) {
    if (text.startsWith('_')) {
      return true;
    } else {
      return false;
    }
  }

  static String removeFirstUnderscore(String text) {
    if (text.startsWith('_')) {
      return text.replaceFirst('_', '');
    }
    return text;
  }

  static String getPremiumStatus(String gender) {
    return (gender == MALE ? ODOGWU : ACHALUGO);
  }

  static void showToast(String message) {
    final isDarkMode = Get.isDarkMode; // Check if dark mode is enabled

    Get.snackbar(
      "Notification", // Title
      message, // Message
      snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
      backgroundColor:
          isDarkMode ? Colors.grey[900] : Colors.white, // Dark or Light mode
      colorText: isDarkMode ? Colors.white : Colors.black, // Text color adapts
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 2), // Auto-dismiss time
      icon: Icon(
        Icons.info,
        color: isDarkMode ? Colors.white : Colors.black, // Icon color adapts
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          spreadRadius: 2,
        ),
      ],
    );
  }

  static String getDeviceCountryCode() {
    // Get locale string like "en_US"
    String locale = ui.PlatformDispatcher.instance.locale.toString();
    // Split and extract country code
    if (locale.contains('_')) {
      return locale.split('_')[1]; // e.g., "US"
    }
    return 'US'; // Default fallback
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

// Function to get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static String baseUrl(value) {
    return '$BASE_URL$value';
  }

  static void showBottomSheet(
      BuildContext context, Widget widget, String headerText,
      {double height = 20}) {
    double screenHeight = MediaQuery.of(context).size.height;
  }

  static const String SEND_MESSAGE_URL = "sendChat";
  static const String SEND_MESSAGE_FOR_BOT_URL = "sendChatForBot";
  static const String SEND_NOTIFICATION_TO_RECIPIENT_URL =
      "sendNotificationToRecipient";
  static const String GET_MATCH_SCORE_URL = "getMatchScore";
  //getMatchScore
  static const String REGISTER_WITH_OTP_URL = "registerWithOtp";
  static const String LOGIN_WITH_OTP_URL = "loginWithOtp";
  static const String VERIFY_OTP_URL = "verifyOTP";
  static const String RESEND_OTP_URL = "resendOtp";
  static const String GET_MESSAGE_URL = "getChats";
  static const String GET_ALL_CHATS_URL = "getAllChats";
  static const String CHECK_EMAIL_URL = "checkEmail";
  static const String REGISTER_URL = "register";
  static const String USER_UPDATE_URL = "user-update";
  static const String UPDATE_REG_URL = "updateReg";
  static const String LOGIN_URL = "login";
  static const String SAVE_IP_URL = "save-ip";
  static const String UPDATE_PUSH_ID = "updatePushNotificationId";
  static const String SWIPE_USER = "swipeUser";
  //swipeUser
  static const String OTHER_USER_INFO_URL = "findOtherUserInfo";
  static const String USER_INFO_URL = "userInfo";
  static const String TOGGLE_VISIBILTY_URL = "toggleVisibility";
  static const String CHECK_IF_REFERRAL_CODE_EXIST_URL = "checkIfRefCodeExist";
  //checkIfRefCodeExist
  static const String LOGOUT_URL = "logout";
  static const String TIMELINE_URL = "newTimeline";
  static const String UPDATE_LOCATION_URL = "updateBasicInfo";
  static const String GET_USER_BASIC_ENUMS = "getUserBasicEnums";
  static const String RELATIONSHIP_PREF_LIST_URL = "allMarriagePreferences";
  static const String UPDATE_RELATIONSHIP_GOAL_URL = "updateRelationGoal";
  static const String HOBBIES_AND_INTEREST_LIST_URL = "allHobbiesAndInterest";
  static const String UPDATE_HOBBIES_AND_INTEREST_URL =
      "updateHobbiesAndInterest";
  static const String ALL_PROMPTS = "allPrompts";
  static const STATE_KEY = 'filter_state';
  static const RELATIONSHIP_KEY = 'filter_relationship';
  static const VERIFIED_KEY = 'filter_verified';
  static const LOCATION_KEY = 'filter_location';
//allPrompts
//getProfileView
  static const String ADD_PROFILE_VIEW_URL = "addProfileView";
  static const String GET_PROFILE_VIEW_URL = "getProfileView";

  static const String UPDATE_FAITH_URL = "updateFaith";
  static const String USER_PHOTO_VERIFICATION_URL = "verifyForUser";
  static const String GET_USER_MATCHES_URL = "getUserMatches";
  static const String BLOCK_USER_URL = "blockUser";
  static const String UNBLOCK_USER_URL = "unblockUser";
  static const String LOGIN_WITH_THIRD_PARTY_URL = "signInWithThirdParty";
  static const String BLOCK_LIST_URL = "blockList";
  static const String BLOCK_MESSAGING_LIST_URL = "blockListMessaging";
  static const String BLOCK_USER_MESSAGE_URL = "blockUserMessaging";
  static const String UNBLOCK_USER_MESSAGE_URL = "unblockUserMessaging";
//blockUserMessaging
  //unblockUserMessaging
  //blockListMessaging
  static const String MARK_AS_READ_URL = "markAsRead";
  static const String HAS_MESSAGED_URL = "hasMessaged";
  //hasMessaged
  static const String UPDATE_PERSONAL_DETAILS_URL = "updatePersonalDetails";
  static const String UPDATE_AGE_PREFERENCE_URL = "updateAgePreference";
//updateAgePreference
  static const String PERSONAL_DETAILS_LIST_URL = "allPersonalDetails";
  static const String SAVE_FAVORITED_BY_URL = "saveFavoritedBy";
  static const String GET_UNREAD_FAVORITED_BY_URL = "getUnreadFavoritedByCount";
  static const String MARK_ALL_FAVORITED_BY_AS_READ_URL =
      "markFavoritedByAsRead";
  //getUnreadFavoritedByCount
  //getMutualFavorites
  static const String GET_MUTUAL_FAVORITE_URL = "getMutualFavorites";
  static const String SAVE_FAVORITE_URL = "saveFavorite";
  static const String GET_FAVORITES_URL = "getFavorites";
  static const String GET_FAITH_LIST_URL = "allFaith";
  static const String GET_MESSAGE_MAX_LIMIT_URL = "messageMaxLimit";
  static const String UPDATE_PARTNER_PREFERENCES_URL =
      "updatePartnerPreference";
  static const String CREATE_FEED_URL = "blogPost-create";
  static const String UPDATE_FEED_URL = "blogPost-update";
  //blogPost-update
  static const String IAM_IGBO = "I am Igbo";
  static const String IAM_NON_IGBO = "I am non-Igbo";

  static const String INTEREST_OUTDOOR = "outdoorActivities";
  static const String INTEREST_SPORT = "sportsActivities";
  static const String INTEREST_BOOK = "bookInterest";
  static const String INTEREST_MUSIC = "musicInterest";
  static const String INTEREST_CREATIVE = "creativeInterest";
  static const String FAVORITE_FOOD = "favoriteFood";

  static const String FAVORITE_FOOD_TITLE = "Favorite Foods";
  static const String INTEREST_OUTDOOR_TITLE = "Outdoor Activities";
  static const String INTEREST_SPORT_TITLE = "Sports Activities";
  static const String INTEREST_BOOK_TITLE = "Book Interest";
  static const String INTEREST_MUSIC_TITLE = "Music Interest";
  static const String INTEREST_CREATIVE_TITLE = "Creative Interest";
  static String getAvatar(String gender) {
    if (gender == "male")
      return "assets/images/male.png";
    else
      return "assets/images/female.png";
  }

  static String calculateAge(String dob) {
    DateTime birthDate = DateTime.parse(dob); // Convert string to DateTime
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;

    // Adjust age if birthday hasn't occurred yet this year
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return "$age";
  }

  
  static void showCustomFlushbar({
    required BuildContext context,
    required String message,
    IconData icon = Icons.info_outline,
    Color? iconColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

   }

  static String formatFacebookTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      // For older posts, format like "Apr 12"
      return '${monthAbbr(date.month)} ${date.day}';
    }
  }

// Helper to get month abbreviation
  static String monthAbbr(int month) {
    const months = [
      '', // placeholder
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  static void shareReferral(BuildContext context, String referralCode) {
    final String message = '''
Hey! 👋  
Check out **IgboCrush**, the app where you can meet amazing Igbo singles from around the world who are ready for love and marriage.  
Download it here 👉 https://onelink.to/uwxzhj  
Don’t forget to enter my referral code: **$referralCode** 💕
''';

    Share.share(message, subject: 'Join me on IgboCrush!');
  }

  
}
