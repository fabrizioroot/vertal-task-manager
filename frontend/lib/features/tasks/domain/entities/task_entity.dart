// frontend/lib/features/tasks/domain/entities/task_entity.dart
/*
 * Copyright 2026 Fabrizio.root
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

class Task {
  final String title;
  final String description;
  final DateTime date;
  final DateTime timeStart;
  final DateTime timeEnd;
  final bool repeat;
  final List<String> repeatDays;
  final bool lastsAllDay;
  final bool isCompleted;

  // Constructor
  Task({
    required this.title,
    this.description = "",
    required this.date,
    required this.timeStart,
    required this.timeEnd,
    this.repeat = false,
    this.repeatDays = const [],
    this.lastsAllDay = false,
    this.isCompleted = false,
  }) {
    final now = DateTime.now();
    // Logic
    if (date.isBefore(now)) {
      throw FormatException("Please enter a valid date.");
    }
    if (timeStart.isBefore(now) || timeEnd.isBefore(now)) {
      throw FormatException("Please enter a valid time.");
    }
    if (timeStart.isAtSameMomentAs(timeEnd)) {
      throw FormatException(
        "Start time and end time cannot be the same value.",
      );
    }
    if (timeEnd.isBefore(timeStart)) {
      throw FormatException(
        "End time cannot start before start time.",
      );
    }
  }
}
