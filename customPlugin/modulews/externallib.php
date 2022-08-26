<?php

// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * External Web Service Template
 *
 * @package    localwstemplate
 * @copyright  2011 Moodle Pty Ltd (http://moodle.com)
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
require_once($CFG->libdir . "/externallib.php");

class local_modulews_external extends external_api
{

    # region add_modules

    /**
     * Describes the parameters for cerate_modules.
     *
     * @return external_external_function_parameters
     * @since Moodle 2.6
     */
    public static function add_modules_parameters()
    {
        return new external_function_parameters(
            array(
                'courseid' => new external_value(PARAM_INT, 'ID of the course'),
                'modules' => new external_multiple_structure(
                    new external_single_structure(
                        array(
                            'modulename' => new external_value(PARAM_TEXT, 'Name of the module'),
                            'section' => new external_value(PARAM_INT, 'Sectionnumber'),
                            'name' => new external_value(PARAM_TEXT, "Title of the module", VALUE_OPTIONAL),
                            'visible' => new external_value(PARAM_INT, '1: available to student, 0:not available', VALUE_OPTIONAL),
                            'description' => new external_value(PARAM_TEXT, 'the new module description', VALUE_OPTIONAL),
                            'descriptionformat' => new external_format_value(PARAM_INT, 'description', VALUE_DEFAULT, 1),
                            'groupmode' => new external_value(PARAM_INT, 'no group, separate, visible', VALUE_DEFAULT, 0),
                            'groupmembersonly' => new external_value(PARAM_INT, '1: yes, 0: no', VALUE_DEFAULT, 0),
                            'groupingid' => new external_value(PARAM_INT, 'grouping id', VALUE_DEFAULT, 0),
                            'options' => new external_multiple_structure(
                                new external_single_structure(
                                    array(
                                        'name' => new external_value(PARAM_TEXT, 'Name of the optional variable to be set'),
                                        'value' => new external_value(PARAM_TEXT, 'Value of the optional variable')
                                    )
                                )
                            )

                        )
                    )
                )
            )
        );
    }

    /**
     * Creates modules
     *
     * @param array $cmids the course module ids
     * @since Moodle 2.6
     */
    public static function add_modules($courseid, $modules)
    {
        global $CFG, $DB;

        require_once($CFG->dirroot . "/course/lib.php");
        require_once($CFG->dirroot . "/course/modlib.php");

        $moduleinfo = new stdClass();
        $course = $DB->get_record('course', array('id' => $courseid), '*', MUST_EXIST);

        // Clean the parameters.
        $params = self::validate_parameters(self::add_modules_parameters(), array('courseid' => $courseid, 'modules' => $modules));

        $context = context_course::instance($course->id);
        require_capability('moodle/course:manageactivities', $context);

        foreach ($params['modules'] as $mod) {
            $module = (object) $mod;
            $moduleobject = $DB->get_record('modules', array('name' => $module->modulename), '*', MUST_EXIST);

            if (trim($module->modulename) == '') {
                throw new invalid_parameter_exception('Invalid module name');
            }

            if (!course_allowed_module($course, $module->modulename)) {
                throw new invalid_parameter_exception('Module "' . $module->modulename . '" is disabled');
            }

            if (is_null($module->visible)) {
                $module->visible = 1;
            }

            if (is_null($module->description)) {
                $module->description = '';
            }

            if (!is_null($module->name) && trim($module->name) != '') {
                $moduleinfo->name = $module->name;
            }

            $moduleinfo->modulename = $module->modulename;

            $moduleinfo->visible = $module->visible;
            $moduleinfo->course = $courseid;
            $moduleinfo->section = $module->section;
            $moduleinfo->introeditor = array('text' => $module->description, 'format' => $module->descriptionformat, 'itemid' => 0);
            $moduleinfo->groupmode = $module->groupmode;
            $moduleinfo->groupmembersonly = $module->groupmembersonly;
            $moduleinfo->groupingid = $module->groupingid;

            if (!empty($mod['options'])) {
                foreach ($mod['options'] as $option) {
                    $value = clean_param($option['value'], PARAM_RAW);

                    $moduleinfo->{$option['name']} = $value;
                }
            }

            $retVal = create_module($moduleinfo);

            $result[] = array('id' => $retVal->id);
        }

        return $result;
    }

    /**
     * Describes the create_modules return value.
     *
     * @return external_single_structure
     * @since Moodle 2.6
     */
    public static function add_modules_returns()
    {
        return new external_multiple_structure(
            new external_single_structure(
                array(
                    'id' => new external_value(PARAM_INT, 'new module id')
                )
            )
        );
    }

    # endregion

    # region edit_folder_files

    public static function edit_folder_files_parameters()
    {
        return new external_function_parameters(
            array(
                'id' => new external_value(PARAM_INT, 'ID of the folder'),
                'itemId' => new external_value(PARAM_INT, "Id new files"),
            )
        );
    }

    public static function edit_folder_files($id, $itemId)
    {
        global $CFG, $DB;

        require_login($course, false, $cm);
        require_once($CFG->dirroot . "/mod/folder/lib.php");
        require_once($CFG->libdir . "/filelib.php");
        require_once($CFG->dirroot . "/course/lib.php");

        $cm = get_coursemodule_from_id('folder', $id, 0, true, MUST_EXIST);
        $context = context_module::instance($cm->id, MUST_EXIST);
        $folder = $DB->get_record('folder', array('id' => $cm->instance), '*', MUST_EXIST);

        $course = $DB->get_record('course', array('id' => $cm->course), '*', MUST_EXIST);
        $courseContext = context_course::instance($course->id);
        require_capability('moodle/course:manageactivities', $courseContext);

        if (is_null($itemId) == false) {
            file_save_draft_area_files($itemId, $context->id, 'mod_folder', 'content', 0, array('subdirs' => true));
        }
    }

    public static function edit_folder_files_returns()
    {
        return null;
    }

    # endregion

    # region edit_folder_name_module

    public static function edit_folder_name_module_parameters()
    {
        return new external_function_parameters(
            array(
                'id' => new external_value(PARAM_INT, 'Module id'),
                'name' => new external_value(PARAM_TEXT, "Title of the module"),
            )
        );
    }

    public static function edit_folder_name_module($id, $name)
    {
        global $CFG, $DB;

        require_login($course, false, $cm);
        require_once($CFG->dirroot . "/mod/folder/lib.php");
        require_once($CFG->libdir . "/filelib.php");
        require_once($CFG->dirroot . "/course/lib.php");

        $cm = get_coursemodule_from_id('folder', $id, 0, true, MUST_EXIST);
        $context = context_module::instance($cm->id, MUST_EXIST);
        $folder = $DB->get_record('folder', array('id' => $cm->instance), '*', MUST_EXIST);

        $course = $DB->get_record('course', array('id' => $cm->course), '*', MUST_EXIST);
        $courseContext = context_course::instance($course->id);
        require_capability('moodle/course:manageactivities', $courseContext);

        set_coursemodule_name($cm->id, $name);
    }

    public static function edit_folder_name_module_returns()
    {
        return null;
    }

    # endregion

    # region add_section_course

    public static function add_section_course_parameters()
    {
        return new external_function_parameters(
            array(
                'courseid' => new external_value(PARAM_INT, 'Course id'),
                'name' => new external_value(PARAM_TEXT, "Name new section"),
            )
        );
    }

    public static function add_section_course($courseid, $name)
    {
        global $CFG, $DB;

        $courseContext = context_course::instance($courseid);
        require_capability('moodle/course:manageactivities', $courseContext);

        $lastsection = (int)$DB->get_field_sql('SELECT max(section) from {course_sections} WHERE course = ?', [$courseid]);

        $cw = new stdClass();
        $cw->course   = $courseid;
        $cw->section  = $lastsection + 1;
        $cw->summary  = '';
        $cw->summaryformat = FORMAT_HTML;
        $cw->sequence = '';
        $cw->name = $name;
        $cw->visible = 1;
        $cw->availability = null;
        $cw->timemodified = time();
        $cw->id = $DB->insert_record("course_sections", $cw);

        core\event\course_section_created::create_from_section($cw)->trigger();
        rebuild_course_cache($courseid, true);

        return $lastsection + 1;
    }

    public static function add_section_course_returns()
    {
        return new external_value(PARAM_INT, 'new section index');
    }

    # endregion

    # region remove_folder_module_course

    public static function remove_folder_module_course_parameters()
    {
        return new external_function_parameters(
            array(
                'cmid' => new external_value(PARAM_INT, 'Module id'),
            )
        );
    }

    public static function remove_folder_module_course($cmid)
    {
        global $CFG, $DB;

        $cm = get_coursemodule_from_id('folder', $cmid, 0, true, MUST_EXIST);
        $context = context_module::instance($cm->id, MUST_EXIST);

        $courseContext = context_course::instance($cm->course);
        require_capability('moodle/course:manageactivities', $courseContext);

        require_once($CFG->dirroot . "/course/lib.php");
        course_delete_module($cmid);
    }

    public static function remove_folder_module_course_returns()
    {
        return null;
    }

    # endregion

    # region update_notes

    public static function update_notes_parameters()
    {
        return new external_function_parameters(
            array(
                'id' => new external_value(PARAM_INT, 'Note id'),
                'content' => new external_value(PARAM_TEXT, 'Content of note'),
            )
        );
    }

    public static function update_notes($id, $text)
    {
        global $CFG, $DB;
        require_once($CFG->dirroot . "/notes/lib.php");

        // Check if note system is enabled.
        if (!$CFG->enablenotes) {
            throw new moodle_exception('notesdisabled', 'notes');
        }

        $notedetails = note_load($id);

        $context = context_course::instance($notedetails->courseid);
        self::validate_context($context);
        require_capability('moodle/notes:manage', $context);
        $notedetails->content = $text;

        note_save($notedetails);
    }

    public static function update_notes_returns()
    {
        return null;
    }

    # endregion

    # region edit_assign

    public static function edit_assign_parameters()
    {
        return new external_function_parameters(
            array(
                'id' => new external_value(PARAM_INT, 'Id of instance'),
                'name' => new external_value(PARAM_TEXT, 'New name of assignmnet',  VALUE_DEFAULT, null),
                'dayStart' => new external_value(PARAM_INT, 'Time stamp day start', VALUE_DEFAULT, null),
                'dayEnd' => new external_value(PARAM_INT, 'Time stamp day end', VALUE_DEFAULT, null),
            )
        );
    }

    public static function edit_assign($id, $name, $dayStart, $dayEnd)
    {
        global $CFG, $DB;
        require_once($CFG->dirroot . "/mod/assign/lib.php");
        require_once($CFG->dirroot . "/mod/assign/locallib.php");
        require_once($CFG->dirroot . "/course/lib.php");

        $cm = get_coursemodule_from_instance('assign', $id, 0, false, MUST_EXIST);
        $context = context_module::instance($cm->id, MUST_EXIST);
        $assign = $DB->get_record('assign', array('id' => $cm->instance), '*', MUST_EXIST);
        $course = $DB->get_record('course', array('id' => $cm->course), '*', MUST_EXIST);
        $courseContext = context_course::instance($course->id);
        require_capability('moodle/course:manageactivities', $courseContext);

        if ($name) {
            $assign->name = $name;
            $cm->name = $name;
        }
        if ($dayStart) {
            $assign->allowsubmissionsfromdate = $dayStart;
        }
        if ($dayEnd) {
            $assign->duedate = $dayEnd;
            $assign->cutoffdate = $dayEnd;
            $assign->gradingduedate = $dayEnd;
        }
        $DB->update_record('course_modules', $cm);
        $assign->instance = $id;
        $context = context_module::instance($cm->id);
        $assignment = new assign($context, null, null);
        $assignment->update_instance($assign);
        rebuild_course_cache($cm->course, true);
    }

    public static function edit_assign_returns()
    {
        return null;
    }

    # endregion

    # region review_quiz

    public static function review_quiz_parameters()
    {
        return new external_function_parameters(
            array(
                'quizid' => new external_value(PARAM_INT, 'Quiz id'),
                'userid' => new external_value(PARAM_INT, 'User id'),
            )
        );
    }

    public static function review_quiz($quizid, $userid)
    {
        global $CFG, $DB;
        require_once($CFG->dirroot . "/mod/quiz/lib.php");

        // Get quiz name & questions
        $attempt = array();
        $attempt['quiz'] = $DB->get_record('quiz', array('id' => $quizid), 'name', MUST_EXIST)->name;
        $quiz_data_sql = "
            SELECT (@cnt := @cnt + 1) AS `id`,
                   `slot`,
                   `id`               AS `qid`,
                   `maxmark`,
                   `name`,
                   `qtype`,
                   `answer`,
                   `fraction`,
                   `feedback`
            FROM `mdl_quiz_slots` AS `slot`
                     CROSS JOIN (SELECT @cnt := 0) AS dummy
                     JOIN (SELECT `id` AS `questionid`, `questiontext` AS `name`, `qtype` FROM `mdl_question`) AS `question`
                          ON `question`.`questionid` = `slot`.`id`
                     LEFT JOIN (SELECT `question` AS `questionid`, `answer`, `fraction`, `feedback`
                                FROM `mdl_question_answers`) AS `answers`
                               ON `answers`.`questionid` = `slot`.`id`
            WHERE `quizid` = ?
            ORDER BY `slot`, `id` ASC;
        ";
        $attempt['questions'] = $DB->get_records_sql($quiz_data_sql, array($quizid));
        $attempt_data_sql = "
            SELECT (@cnt := @cnt + 1) AS `id`, `userid`, `id` as `attemptstepid`, `value` AS `answer`
            FROM `mdl_question_attempt_steps` as `step`
                     CROSS JOIN (SELECT @cnt := 0) AS dummy
                     JOIN (SELECT `attemptstepid`, `value` FROM `mdl_question_attempt_step_data` WHERE `name` = 'answer') AS `data`
                          ON `data`.`attemptstepid` = `step`.`id`
            WHERE `userid` = ?
              AND `state` = 'complete';
        ";
        $attempt['answers'] = $DB->get_records_sql($attempt_data_sql, array($userid));

        return $attempt;
    }

    public static function review_quiz_returns()
    {
        return new external_single_structure(
            array(
                'quiz' => new external_value(PARAM_TEXT, 'Quiz name'),
                'questions' => new external_multiple_structure(
                    new external_single_structure(
                        array(
                            'id' => new external_value(PARAM_INT, 'Id'),
                            'slot' => new external_value(PARAM_INT, 'Question order in quiz'),
                            'qid' => new external_value(PARAM_INT, 'Question id'),
                            'maxmark' => new external_value(PARAM_FLOAT, 'Question max mark'),
                            'name' => new external_value(PARAM_RAW, 'Question title'),
                            'qtype' => new external_value(PARAM_TEXT, 'Question type'),
                            'answer' => new external_value(PARAM_RAW, 'One of question answers'),
                            'fraction' => new external_value(PARAM_FLOAT, 'Score percentage for this answer (relative to maxmark'),
                            'feedback' => new external_value(PARAM_TEXT, 'Teacher feedback'),
                        )
                    )
                ),
                'answers' => new external_multiple_structure(
                    new external_single_structure(
                        array(
                            'id' => new external_value(PARAM_INT, 'Id'),
                            'userid' => new external_value(PARAM_INT, 'User id'),
                            'attemptstepid' => new external_value(PARAM_INT, 'Attempt step id'),
                            'answer' => new external_value(PARAM_RAW, 'Answer'),
                        )
                    )
                ),
            )
        );
    }

    public static function quiz_set_grades_parameters()
    {
        return new external_function_parameters(
            array(
                'attemptid' => new external_value(PARAM_INT, 'Attempt id'),
                'slotid' => new external_value(PARAM_INT, 'Slot id of question'),
                'mark' => new external_value(PARAM_FLOAT, 'Mark for questions'),
                'comment' => new external_value(PARAM_TEXT, 'Comment for questions')
            )
        );
    }

    public static function quiz_set_grades($attemptid, $slot, $mark, $comment)
    {
        global $CFG, $DB;
        require_once($CFG->dirroot . "/mod/quiz/lib.php");
        require_once($CFG->dirroot . "/mod/quiz/locallib.php");
        require_once($CFG->dirroot . "/mod/quiz/attemptlib.php");
        require_once($CFG->dirroot . "/question/engine/questionattempt.php");

        // Get attempt obj
        $attempt = quiz_create_attempt_handling_errors($attemptid);
        //$attempt->preload_all_attempt_step_users();

        // Can only grade finished attempts.
        if (!$attempt->is_finished()) {
            throw new \moodle_exception('attemptclosed', 'quiz');
        }

        // Check login and permissions
        $attempt->require_capability('mod/quiz:grade');

        // grading
        $uniqueid = $attempt->get_uniqueid();
        $qid = $attempt->get_question_attempt($slot);

        $transaction = $DB->start_delegated_transaction();
        $qid->manual_grade($comment, $mark, null, time());
        $attempt->process_submitted_actions(time());
        $transaction->allow_commit();

        // trigger event
        $params = array(
            'objectid' => $qid->get_question_id(),
            'courseid' => $attempt->get_courseid(),
            'context' => context_module::instance($attempt->get_cmid()),
            'other' => array(
                'quizid' => $attempt->get_quizid(),
                'attemptid' => $attempt->get_attemptid(),
                'slot' => $slot,
            )
        );
        $event = \mod_quiz\event\question_manually_graded::create($params);
        $event->trigger();

        //rebuild_course_cache($attempt->get_courseid(), true);
    }

    public static function quiz_set_grades_returns()
    {
        return null;
    } 

    public static function delete_module_parameters()
    {
        return new external_function_parameters(
            array(
                'cmid' => new external_value(PARAM_INT, 'Course module id'),
		'courseid' => new external_value(PARAM_INT, 'Course id'),
            )
        );
    }

    public static function delete_module($cmid, $courseid)
    {
        global $CFG, $DB;
        require_once($CFG->dirroot . "/course/lib.php");

        $courseContext = context_course::instance($courseid);
        require_capability('moodle/course:manageactivities', $courseContext);

	course_delete_module($cmid);
    }

    public static function delete_module_returns()
    {
        return null;
    } 

    # endregion
}
