class Api {

  static final String host = "https://delta.nitt.edu/recal-uae/api/";
  static final String checkLogin = host + "auth/check_login";
  static final String login = host + "auth/app_login/";
  static final String passwordReset = host + "auth/pass_reset";
  static final String passwordUpdate = host + "auth/pass_update";
  static final String feedbackMessage = host + "feedback/send";
  static final String chapterCore = host + "chapter/core/";
  static final String chapterVisionMission = host + "chapter/";
  static final String writeAdmin = host + "employment/write_admin";
  static final String getUser = host + "users/profile/";
  static final String updateuser = host + "users/update/";
  static final String addFile = host + "users/add_file/";
  static final String logout = host + "auth/logout/";
  static final String alumniPlaced = host + "employment/alumni_placed";
  static final String businessMembers = host + "business/members/";
  static final String addBranch = host + "branch/add/";
  static final String linkedinProfile = host + "employment/linked_profiles";
  static final String marketSurvey = host + "employment/market_survey";
  static final String allUsers = host + "users/all_users/";
  static final String mentorGroups = host + "mentor_group/groups";
  static final String getNotification = host + "notifications/get_notification?id=";
  static final String getAllNotifications = host + "notifications/?id=";
  static final String getPosition = host + "employment/positions";
  static final String seekGuidance = host + "employment/seek_guidance";
  static final String writeResume = host + "employment/write_resume";
  static final String writeMentor = host + "employment/write_mentor";
  static final String getAchievements = host + "achievements/";
  static final String getAccount = host + "events/accounts/";
  static final String getAllAccounts = host + "events/all_accounts/";
  static final String getSocialMedia = host + "events/social_media/";
  static final String getManage = host + "events/manage/";
  static final String getSponsors = host + "events/sponsors/";
  static final String getFelicitations = host + "events/felicitations/";
  static final String getAllEvents = host + "events/all_events/";
  static final String getAttendees = host + "event/attendees/";
}
