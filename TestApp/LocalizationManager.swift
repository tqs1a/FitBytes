//
//  LocalizationManager.swift
//  TestApp
//
//  Manages app localization and language switching
//

import SwiftUI
import Combine

// Supported languages
enum AppLanguage: String, CaseIterable {
    case english = "en"
    case german = "de"
    
    // Display name with both English and native name
    var displayName: String {
        switch self {
        case .english: return "English"
        case .german: return "German - Deutsch"
        }
    }
    
    // Native name only
    var nativeName: String {
        switch self {
        case .english: return "English"
        case .german: return "Deutsch"
        }
    }
}

// Localization manager to handle language switching
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @AppStorage("app_language") var selectedLanguage: String = "de" {
        didSet {
            objectWillChange.send()
        }
    }
    
    private init() {}
    
    // Get localized string for a key
    func localizedString(_ key: String) -> String {
        guard let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return key
        }
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
    
    // Set language
    func setLanguage(_ language: AppLanguage) {
        selectedLanguage = language.rawValue
    }
    
    // Get current language
    var currentLanguage: AppLanguage {
        return AppLanguage(rawValue: selectedLanguage) ?? .german
    }
    
    // Map exercise name to localization key (for preset exercises)
    func localizationKeyForExercise(name: String) -> String? {
        let mapping: [String: String] = [
            "Bench Press": LocalizedKey.exerciseBenchPress,
            "Push-ups": LocalizedKey.exercisePushUps,
            "Dumbbell Flyes": LocalizedKey.exerciseDumbbellFlyes,
            "Incline Bench Press": LocalizedKey.exerciseInclineBenchPress,
            "Deadlift": LocalizedKey.exerciseDeadlift,
            "Pull-ups": LocalizedKey.exercisePullUps,
            "Bent Over Row": LocalizedKey.exerciseBentOverRow,
            "Lat Pulldown": LocalizedKey.exerciseLatPulldown,
            "Squat": LocalizedKey.exerciseSquat,
            "Lunges": LocalizedKey.exerciseLunges,
            "Leg Press": LocalizedKey.exerciseLegPress,
            "Romanian Deadlift": LocalizedKey.exerciseRomanianDeadlift,
            "Overhead Press": LocalizedKey.exerciseOverheadPress,
            "Lateral Raise": LocalizedKey.exerciseLateralRaise,
            "Face Pulls": LocalizedKey.exerciseFacePulls,
            "Barbell Curl": LocalizedKey.exerciseBarbellCurl,
            "Tricep Dips": LocalizedKey.exerciseTricepDips,
            "Hammer Curls": LocalizedKey.exerciseHammerCurls,
            "Tricep Pushdown": LocalizedKey.exerciseTricepPushdown,
            "Plank": LocalizedKey.exercisePlank,
            "Russian Twists": LocalizedKey.exerciseRussianTwists,
            "Hanging Leg Raises": LocalizedKey.exerciseHangingLegRaises,
            "Cable Crunches": LocalizedKey.exerciseCableCrunches,
            "Running": LocalizedKey.exerciseRunning,
            "Cycling": LocalizedKey.exerciseCycling,
            "Jump Rope": LocalizedKey.exerciseJumpRope,
            "Burpees": LocalizedKey.exerciseBurpees,
            "Clean and Press": LocalizedKey.exerciseCleanAndPress,
            "Kettlebell Swings": LocalizedKey.exerciseKettlebellSwings,
            "Turkish Get-Up": LocalizedKey.exerciseTurkishGetUp
        ]
        return mapping[name]
    }
}

// SwiftUI helper for localization
extension String {
    func localized() -> String {
        return LocalizationManager.shared.localizedString(self)
    }
}

// Localization keys - centralized for easy reference
struct LocalizedKey {
    // Tab Bar
    static let tabHome = "tab.home"
    static let tabActivity = "tab.activity"
    static let tabProgress = "tab.progress"
    static let tabProfile = "tab.profile"
    
    // Home Screen
    static let welcomeBack = "home.welcome_back"
    static let readyForWorkout = "home.ready_for_workout"
    static let quickActions = "home.quick_actions"
    static let workoutStart = "home.workout_start"
    static let quickTraining = "home.quick_training"
    static let nutritionTrack = "home.nutrition_track"
    static let trackCalories = "home.track_calories"
    static let today = "home.today"
    
    // Stats
    static let steps = "stats.steps"
    static let calories = "stats.calories"
    static let activity = "stats.activity"
    static let water = "stats.water"
    static let minutes = "stats.minutes"
    static let glasses = "stats.glasses"
    static let distance = "stats.distance"
    static let heartRate = "stats.heart_rate"
    static let sleep = "stats.sleep"
    static let caloriesEaten = "stats.calories_eaten"
    static let of = "stats.of"
    
    // Activity Feed
    static let activities = "activity.activities"
    static let aiOverview = "activity.ai_overview"
    static let todayPeriod = "activity.today"
    static let weekPeriod = "activity.week"
    static let workouts = "activity.workouts"
    
    // Workout Screen
    static let workout = "workout.title"
    static let workoutTypes = "workout.types"
    static let recentWorkouts = "workout.recent"
    static let startWorkout = "workout.start"
    static let running = "workout.running"
    static let cycling = "workout.cycling"
    static let strength = "workout.strength"
    static let yoga = "workout.yoga"
    static let swimming = "workout.swimming"
    
    // Nutrition Screen
    static let nutrition = "nutrition.title"
    static let dailyGoal = "nutrition.daily_goal"
    static let breakfast = "nutrition.breakfast"
    static let lunch = "nutrition.lunch"
    static let dinner = "nutrition.dinner"
    static let snacks = "nutrition.snacks"
    static let addMeal = "nutrition.add_meal"
    static let waterIntake = "nutrition.water_intake"
    static let macros = "nutrition.macros"
    
    // Profile & Settings
    static let profile = "profile.title"
    static let settings = "profile.settings"
    static let statistics = "profile.statistics"
    static let preferences = "profile.preferences"
    static let editProfile = "profile.edit"
    static let quickOverview = "profile.quick_overview"
    static let weight = "profile.weight"
    static let bmi = "profile.bmi"
    static let goal = "profile.goal"
    
    // Settings Screen
    static let language = "settings.language"
    static let customizeHomeStats = "settings.customize_home_stats"
    static let notifications = "settings.notifications"
    static let privacy = "settings.privacy"
    static let security = "settings.security"
    static let helpSupport = "settings.help_support"
    static let about = "settings.about"
    static let otherSettings = "settings.other_settings"
    static let editHomeStats = "settings.edit_home_stats"
    static let statsEnabled = "settings.stats_enabled"
    static let preview = "settings.preview"
    static let notificationsSubtitle = "settings.notifications_subtitle"
    static let privacySubtitle = "settings.privacy_subtitle"
    static let securitySubtitle = "settings.security_subtitle"
    static let helpSupportSubtitle = "settings.help_support_subtitle"
    static let aboutVersion = "settings.about_version"
    static let weightUnit = "settings.weight_unit"
    static let weightUnitKilograms = "settings.weight_unit_kg"
    static let weightUnitPounds = "settings.weight_unit_lbs"
    
    // Programs & Workouts
    static let myPrograms = "program.my_programs"
    static let createNewProgram = "program.create_new"
    static let programName = "program.program_name"
    static let enterName = "program.enter_name"
    static let selectImage = "program.select_image"
    static let photoLibrary = "program.photo_library"
    static let presetIcons = "program.preset_icons"
    static let emptyState = "program.empty_state"
    static let emptySubtitle = "program.empty_subtitle"
    static let lastCompleted = "program.last_completed"
    static let neverCompleted = "program.never_completed"
    static let timesCompleted = "program.times_completed"
    static let createProgram = "program.create"
    static let programExercises = "program.exercises"
    static let editProgram = "program.edit"
    static let saveChanges = "program.save_changes"
    static let addExercise = "program.add_exercise"
    static let noExercisesYet = "program.no_exercises_yet"
    static let addExercisesToStart = "program.add_exercises_to_start"
    static let removeExercise = "program.remove_exercise"
    static let removeExerciseConfirm = "program.remove_exercise_confirm"
    static let remove = "program.remove"
    static let sets = "program.sets"
    static let reps = "program.reps"
    static let notes = "program.notes"
    static let addNotes = "program.add_notes"
    static let rest = "program.rest"
    
    // Exercise Library
    static let exerciseLibrary = "exercise.library"
    static let allExercises = "exercise.all_exercises"
    static let favorites = "exercise.favorites"
    static let searchExercises = "exercise.search"
    static let filterBy = "exercise.filter_by"
    static let noFavorites = "exercise.no_favorites"
    static let tapStar = "exercise.tap_star"
    static let exerciseDetails = "exercise.details"
    static let instructions = "exercise.instructions"
    static let muscleGroups = "exercise.muscle_groups"
    static let demonstration = "exercise.demonstration"
    static let addToProgram = "exercise.add_to_program"
    static let custom = "exercise.custom"
    static let preset = "exercise.preset"
    
    // Exercise Names (Preset exercises)
    static let exerciseBenchPress = "exercise.name.bench_press"
    static let exercisePushUps = "exercise.name.push_ups"
    static let exerciseDumbbellFlyes = "exercise.name.dumbbell_flyes"
    static let exerciseInclineBenchPress = "exercise.name.incline_bench_press"
    static let exerciseDeadlift = "exercise.name.deadlift"
    static let exercisePullUps = "exercise.name.pull_ups"
    static let exerciseBentOverRow = "exercise.name.bent_over_row"
    static let exerciseLatPulldown = "exercise.name.lat_pulldown"
    static let exerciseSquat = "exercise.name.squat"
    static let exerciseLunges = "exercise.name.lunges"
    static let exerciseLegPress = "exercise.name.leg_press"
    static let exerciseRomanianDeadlift = "exercise.name.romanian_deadlift"
    static let exerciseOverheadPress = "exercise.name.overhead_press"
    static let exerciseLateralRaise = "exercise.name.lateral_raise"
    static let exerciseFacePulls = "exercise.name.face_pulls"
    static let exerciseBarbellCurl = "exercise.name.barbell_curl"
    static let exerciseTricepDips = "exercise.name.tricep_dips"
    static let exerciseHammerCurls = "exercise.name.hammer_curls"
    static let exerciseTricepPushdown = "exercise.name.tricep_pushdown"
    static let exercisePlank = "exercise.name.plank"
    static let exerciseRussianTwists = "exercise.name.russian_twists"
    static let exerciseHangingLegRaises = "exercise.name.hanging_leg_raises"
    static let exerciseCableCrunches = "exercise.name.cable_crunches"
    static let exerciseRunning = "exercise.name.running"
    static let exerciseCycling = "exercise.name.cycling"
    static let exerciseJumpRope = "exercise.name.jump_rope"
    static let exerciseBurpees = "exercise.name.burpees"
    static let exerciseCleanAndPress = "exercise.name.clean_and_press"
    static let exerciseKettlebellSwings = "exercise.name.kettlebell_swings"
    static let exerciseTurkishGetUp = "exercise.name.turkish_get_up"
    
    // Muscle Groups
    static let muscleChest = "muscle.chest"
    static let muscleBack = "muscle.back"
    static let muscleLegs = "muscle.legs"
    static let muscleShoulders = "muscle.shoulders"
    static let muscleArms = "muscle.arms"
    static let muscleCore = "muscle.core"
    static let muscleCardio = "muscle.cardio"
    static let muscleFullBody = "muscle.full_body"
    static let muscleAll = "muscle.all"
    
    // Common
    static let done = "common.done"
    static let cancel = "common.cancel"
    static let save = "common.save"
    static let edit = "common.edit"
    static let add = "common.add"
    static let delete = "common.delete"
    static let share = "common.share"
    static let loading = "common.loading"
    static let create = "common.create"
    static let search = "common.search"
}

