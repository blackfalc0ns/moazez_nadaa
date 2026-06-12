/// API Endpoints Constants
/// Centralized location for all API endpoint paths
class ApiEndpoints {
  ApiEndpoints._();

  // ==================== Auth ====================
  
  /// Login endpoint
  /// POST /auth/login
  static const String login = '/auth/login';

  /// Get current user endpoint
  /// GET /auth/me
  static const String me = '/auth/me';

  /// Refresh token endpoint
  /// POST /auth/refresh
  static const String refresh = '/auth/refresh';

  /// Logout endpoint
  /// POST /auth/logout
  static const String logout = '/auth/logout';

  /// Change password endpoint
  /// POST /auth/change-password
  static const String changePassword = '/auth/change-password';

  // ==================== Teacher Home ====================

  /// Teacher home dashboard
  /// GET /teacher/home
  static const String teacherHome = '/teacher/home';

  // ==================== Teacher Profile ====================

  /// Teacher profile
  /// GET /teacher/profile
  static const String teacherProfile = '/teacher/profile';

  /// Teacher employment profile
  /// GET /teacher/profile/employment
  static const String teacherEmployment = '/teacher/profile/employment';

  // ==================== Teacher Settings ====================

  /// Settings about
  /// GET /teacher/settings/about
  static const String settingsAbout = '/teacher/settings/about';

  /// Settings contact
  /// GET /teacher/settings/contact
  static const String settingsContact = '/teacher/settings/contact';

  // ==================== My Classes ====================

  /// List teacher classes
  /// GET /teacher/my-classes
  static const String myClasses = '/teacher/my-classes';

  /// Get class detail
  /// GET /teacher/my-classes/:classId
  static String myClassDetail(String classId) => '/teacher/my-classes/$classId';

  // ==================== Classroom ====================

  /// Get classroom detail
  /// GET /teacher/classroom/:classId
  static String classroom(String classId) => '/teacher/classroom/$classId';

  /// Get classroom roster
  /// GET /teacher/classroom/:classId/roster
  static String classroomRoster(String classId) =>
      '/teacher/classroom/$classId/roster';

  // ==================== Attendance ====================

  /// Get attendance roster
  /// GET /teacher/classroom/:classId/attendance/roster
  static String attendanceRoster(String classId) =>
      '/teacher/classroom/$classId/attendance/roster';

  /// Resolve attendance session
  /// POST /teacher/classroom/:classId/attendance/session/resolve
  static String attendanceResolve(String classId) =>
      '/teacher/classroom/$classId/attendance/session/resolve';

  /// Get attendance session
  /// GET /teacher/classroom/:classId/attendance/sessions/:sessionId
  static String attendanceSession(String classId, String sessionId) =>
      '/teacher/classroom/$classId/attendance/sessions/$sessionId';

  /// Update attendance entries
  /// PUT /teacher/classroom/:classId/attendance/sessions/:sessionId/entries
  static String attendanceEntries(String classId, String sessionId) =>
      '/teacher/classroom/$classId/attendance/sessions/$sessionId/entries';

  /// Submit attendance session
  /// POST /teacher/classroom/:classId/attendance/sessions/:sessionId/submit
  static String attendanceSubmit(String classId, String sessionId) =>
      '/teacher/classroom/$classId/attendance/sessions/$sessionId/submit';

  // ==================== Grades ====================

  /// List assessments
  /// GET /teacher/classroom/:classId/grades/assessments
  static String assessments(String classId) =>
      '/teacher/classroom/$classId/grades/assessments';

  /// Get assessment detail
  /// GET /teacher/classroom/:classId/grades/assessments/:assessmentId
  static String assessmentDetail(String classId, String assessmentId) =>
      '/teacher/classroom/$classId/grades/assessments/$assessmentId';

  /// Get gradebook
  /// GET /teacher/classroom/:classId/grades/gradebook
  static String gradebook(String classId) =>
      '/teacher/classroom/$classId/grades/gradebook';

  // ==================== Assignments ====================

  /// List assignments
  /// GET /teacher/classroom/:classId/assignments
  static String assignments(String classId) =>
      '/teacher/classroom/$classId/assignments';

  /// Get assignment detail
  /// GET /teacher/classroom/:classId/assignments/:assignmentId
  static String assignmentDetail(String classId, String assignmentId) =>
      '/teacher/classroom/$classId/assignments/$assignmentId';

  /// List submissions
  /// GET /teacher/classroom/:classId/assignments/:assignmentId/submissions
  static String assignmentSubmissions(String classId, String assignmentId) =>
      '/teacher/classroom/$classId/assignments/$assignmentId/submissions';

  /// Get submission detail
  /// GET /teacher/classroom/:classId/assignments/:assignmentId/submissions/:submissionId
  static String submissionDetail(
    String classId,
    String assignmentId,
    String submissionId,
  ) => '/teacher/classroom/$classId/assignments/$assignmentId/submissions/$submissionId';

  /// Review single answer
  /// PATCH /teacher/classroom/:classId/assignments/:assignmentId/submissions/:submissionId/answers/:answerId/review
  static String reviewAnswer(
    String classId,
    String assignmentId,
    String submissionId,
    String answerId,
  ) => '/teacher/classroom/$classId/assignments/$assignmentId/submissions/$submissionId/answers/$answerId/review';

  /// Bulk review answers
  /// PUT /teacher/classroom/:classId/assignments/:assignmentId/submissions/:submissionId/answers/review
  static String bulkReviewAnswers(
    String classId,
    String assignmentId,
    String submissionId,
  ) => '/teacher/classroom/$classId/assignments/$assignmentId/submissions/$submissionId/answers/review';

  /// Finalize review
  /// POST /teacher/classroom/:classId/assignments/:assignmentId/submissions/:submissionId/review/finalize
  static String finalizeReview(
    String classId,
    String assignmentId,
    String submissionId,
  ) => '/teacher/classroom/$classId/assignments/$assignmentId/submissions/$submissionId/review/finalize';

  /// Sync grade item
  /// POST /teacher/classroom/:classId/assignments/:assignmentId/submissions/:submissionId/sync-grade-item
  static String syncGradeItem(
    String classId,
    String assignmentId,
    String submissionId,
  ) => '/teacher/classroom/$classId/assignments/$assignmentId/submissions/$submissionId/sync-grade-item';

  // ==================== Teacher Tasks ====================

  /// Teacher tasks dashboard
  /// GET /teacher/tasks/dashboard
  static const String teacherTasksDashboard = '/teacher/tasks/dashboard';

  /// Teacher tasks selectors
  /// GET /teacher/tasks/selectors
  static const String teacherTasksSelectors = '/teacher/tasks/selectors';

  /// List teacher tasks
  /// GET /teacher/tasks
  static const String teacherTasks = '/teacher/tasks';

  /// Get teacher task detail
  /// GET /teacher/tasks/:taskId
  static String teacherTask(String taskId) => '/teacher/tasks/$taskId';

  // ==================== Task Review Queue ====================

  /// List review queue
  /// GET /teacher/tasks/review-queue
  static const String teacherReviewQueue = '/teacher/tasks/review-queue';

  /// Get review queue submission detail
  /// GET /teacher/tasks/review-queue/:submissionId
  static String teacherReviewQueueSubmission(String submissionId) => '/teacher/tasks/review-queue/$submissionId';

  /// Approve review queue submission
  /// POST /teacher/tasks/review-queue/:submissionId/approve
  static String teacherReviewQueueApprove(String submissionId) => '/teacher/tasks/review-queue/$submissionId/approve';

  /// Reject review queue submission
  /// POST /teacher/tasks/review-queue/:submissionId/reject
  static String teacherReviewQueueReject(String submissionId) => '/teacher/tasks/review-queue/$submissionId/reject';

  // ==================== Teacher XP ====================

  /// Teacher XP dashboard
  /// GET /teacher/xp/dashboard
  static const String teacherXpDashboard = '/teacher/xp/dashboard';

  /// Class XP
  /// GET /teacher/xp/classes/:classId
  static String teacherXpClass(String classId) => '/teacher/xp/classes/$classId';

  /// Student XP
  /// GET /teacher/xp/students/:studentId
  static String teacherXpStudent(String studentId) => '/teacher/xp/students/$studentId';

  /// Student XP history
  /// GET /teacher/xp/students/:studentId/history
  static String teacherXpStudentHistory(String studentId) => '/teacher/xp/students/$studentId/history';

  // ==================== Teacher Schedule ====================

  /// Teacher daily schedule
  /// GET /teacher/schedule
  static const String teacherSchedule = '/teacher/schedule';

  /// Teacher weekly schedule
  /// GET /teacher/schedule/week
  static const String teacherScheduleWeek = '/teacher/schedule/week';

  // ==================== Teacher Messages ====================

  /// List conversations
  /// GET /teacher/messages/conversations
  static const String teacherConversations = '/teacher/messages/conversations';

  /// Get conversation
  /// GET /teacher/messages/conversations/:conversationId
  static String teacherConversation(String conversationId) => '/teacher/messages/conversations/$conversationId';

  /// List messages
  /// GET /teacher/messages/conversations/:conversationId/messages
  static String teacherMessages(String conversationId) => '/teacher/messages/conversations/$conversationId/messages';

  /// Send message
  /// POST /teacher/messages/conversations/:conversationId/messages
  static String teacherSendMessage(String conversationId) => '/teacher/messages/conversations/$conversationId/messages';

  /// Mark conversation as read
  /// POST /teacher/messages/conversations/:conversationId/read
  static String teacherMarkConversationRead(String conversationId) => '/teacher/messages/conversations/$conversationId/read';

  /// Mark individual message as read
  /// POST /teacher/messages/:messageId/read
  static String teacherMarkMessageRead(String messageId) => '/teacher/messages/$messageId/read';

  /// Get conversation read summary
  /// GET /communication/conversations/:conversationId/read-summary
  static String teacherConversationReadSummary(String conversationId) => '/communication/conversations/$conversationId/read-summary';

  /// Close conversation
  /// POST /communication/conversations/:conversationId/close
  static String teacherCloseConversation(String conversationId) => '/communication/conversations/$conversationId/close';

  /// Reopen conversation
  /// POST /communication/conversations/:conversationId/reopen
  static String teacherReopenConversation(String conversationId) => '/communication/conversations/$conversationId/reopen';

  /// Archive conversation
  /// POST /communication/conversations/:conversationId/archive
  static String teacherArchiveConversation(String conversationId) => '/communication/conversations/$conversationId/archive';

  /// Edit message
  /// PATCH /communication/messages/:messageId
  static String teacherEditMessage(String messageId) => '/communication/messages/$messageId';

  /// Delete message
  /// DELETE /communication/messages/:messageId
  static String teacherDeleteMessage(String messageId) => '/communication/messages/$messageId';

  /// Add/Update reaction
  /// PUT /communication/messages/:messageId/reactions
  static String teacherReaction(String messageId) => '/communication/messages/$messageId/reactions';

  /// List message reactions
  /// GET /communication/messages/:messageId/reactions
  static String teacherMessageReactions(String messageId) => '/communication/messages/$messageId/reactions';

  /// Delete my reaction
  /// DELETE /communication/messages/:messageId/reactions/me
  static String teacherDeleteMyReaction(String messageId) => '/communication/messages/$messageId/reactions/me';

  /// Upload file
  /// POST /files
  static const String uploadFile = '/files';

  /// Link attachment to message
  /// POST /communication/messages/:messageId/attachments
  static String teacherLinkAttachment(String messageId) => '/communication/messages/$messageId/attachments';

  /// Delete attachment
  /// DELETE /communication/messages/:messageId/attachments/:attachmentId
  static String teacherDeleteAttachment(String messageId, String attachmentId) => '/communication/messages/$messageId/attachments/$attachmentId';

  // ==========================================
  // Group & Participants Management
  // ==========================================

  /// Update conversation metadata
  /// PATCH /communication/conversations/:conversationId
  static String teacherUpdateConversation(String conversationId) => '/communication/conversations/$conversationId';

  /// List participants
  /// GET /communication/conversations/:conversationId/participants
  static String teacherParticipants(String conversationId) => '/communication/conversations/$conversationId/participants';

  /// Add participant
  /// POST /communication/conversations/:conversationId/participants
  static String teacherAddParticipant(String conversationId) => '/communication/conversations/$conversationId/participants';

  /// Update participant role
  /// PATCH /communication/conversations/:conversationId/participants/:participantId
  static String teacherUpdateParticipant(String conversationId, String participantId) => '/communication/conversations/$conversationId/participants/$participantId';

  /// Remove participant
  /// DELETE /communication/conversations/:conversationId/participants/:participantId
  static String teacherRemoveParticipant(String conversationId, String participantId) => '/communication/conversations/$conversationId/participants/$participantId';

  // ==========================================
  // Safety & Moderation (Sprint 7B)
  // ==========================================

  /// Report message
  /// POST /communication/messages/:messageId/reports
  static String teacherReportMessage(String messageId) => '/communication/messages/$messageId/reports';

  /// List message reports
  /// GET /communication/message-reports
  static const String teacherReports = '/communication/message-reports';

  /// Update message report
  /// PATCH /communication/message-reports/:reportId
  static String teacherUpdateReport(String reportId) => '/communication/message-reports/$reportId';

  /// Moderate message (hide, unhide, etc)
  /// POST /communication/messages/:messageId/moderation-actions
  static String teacherModerateMessage(String messageId) => '/communication/messages/$messageId/moderation-actions';

  /// List blocks
  /// GET /communication/blocks
  static const String teacherBlocks = '/communication/blocks';

  /// Block user
  /// POST /communication/blocks
  static const String teacherBlockUser = '/communication/blocks';

  /// Unblock user
  /// DELETE /communication/blocks/:blockId
  static String teacherUnblockUser(String blockId) => '/communication/blocks/$blockId';

  /// List restrictions
  /// GET /communication/restrictions
  static const String teacherRestrictions = '/communication/restrictions';

  /// Add restriction
  /// POST /communication/restrictions
  static const String teacherAddRestriction = '/communication/restrictions';

  /// Update restriction
  /// PATCH /communication/restrictions/:restrictionId
  static String teacherUpdateRestriction(String restrictionId) => '/communication/restrictions/$restrictionId';

  /// Remove restriction
  /// DELETE /communication/restrictions/:restrictionId
  static String teacherRemoveRestriction(String restrictionId) => '/communication/restrictions/$restrictionId';
}
