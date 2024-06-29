const createCourses = '''
CREATE TABLE courses(
    code          TEXT NOT NULL PRIMARY KEY,
    name          TEXT NOT NULL,
    classId       TEXT NOT NULL,
    professors    TEXT NOT NULL,
    absences      INTEGER NOT NULL,
    absenceLimit  INTEGER NOT NULL,
    totalHours    INTEGER NOT NULL,
    credits       INTEGER NOT NULL
)  ''';

const createGrades = '''
CREATE TABLE grades(
    id      INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    value   TEXT NOT NULL,
    weight  TEXT NOT NULL,
    label   TEXT NOT NULL,
    course  TEXT REFERENCES courses (code)
)  ''';

const createSchedules = '''
CREATE TABLE schedules(
    id          INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    weekday     INTEGEREGER NOT NULL,
    startTime   TEXT NOT NULL,
    endTime     TEXT NOT NULL,
    local       TEXT NOT NULL,
    localShort  TEXT NOT NULL,
    course      TEXT REFERENCES courses (code)
)  ''';

const createHistory = '''
CREATE TABLE history(
    code       TEXT NOT NULL PRIMARY KEY,
    name       TEXT NOT NULL,
    professors TEXT NOT NULL,
    semester   TEXT NOT NULL,
    totalHours TEXT NOT NULL,
    grade      TEXT NOT NULL,
    status     TEXT NOT NULL,
    type       TEXT NOT NULL,
    credits    TEXT NOT NULL
) ''';

const createSettings = '''
CREATE TABLE preferences(
    id                  INTEGER NOT NULL PRIMARY KEY DEFAULT 1,
    themeMode           INTEGER NOT NULL,
    themePref           INTEGER NOT NULL,
    seedColor           INTEGER,
    backgroundSync      INTEGER NOT NULL,
    showNotifications   INTEGER NOT NULL,
    lastSync            TEXT
)  ''';

const createAssessments = '''
CREATE TABLE assignments(
    id           INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    assignmentId TEXT    NOT NULL,
    course       INTEGER NOT NULL REFERENCES courses (id),
    courseId     TEXT    NOT NULL,
    name         TEXT    NOT NULL,
    subject      TEXT    NOT NULL,
    description  TEXT    NOT NULL,
    isDone       INTEGER NOT NULL DEFAULT 0,
    notify       INTEGER NOT NULL DEFAULT 0,
    createdAt    TEXT    NOT NULL,
    updatedAt    TEXT,
    dueDate      TEXT    NOT NULL
); ''';

const createProfiles = '''
CREATE TABLE profiles(
    id          INTEGER NOT NULL PRIMARY KEY,
    register    TEXT NOT NULL,
    name        TEXT NOT NULL,
    program     TEXT NOT NULL,
    campus      TEXT NOT NULL,
    totalHours  TEXT NOT NULL,
    credits     TEXT NOT NULL,
    avatar      TEXT NOT NULL
)  ''';

const createAcademicIndexes = '''
CREATE TABLE academic_indexes(
    id      INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    label   TEXT NOT NULL,
    value   TEXT NOT NULL,
    profile INTEGER REFERENCES profiles (id)
)  ''';
