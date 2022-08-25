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
 * Web service local plugin template external functions and service definitions.
 *
 * @package    localwstemplate
 * @copyright  2011 Jerome Mouneyrac
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

// We defined the web service functions to install.
$functions = array(
        'local_modulews_add_modules' => array(
                'classname'   => 'local_modulews_external',
                'methodname'  => 'add_modules',
                'classpath'   => 'local/modulews/externallib.php',
                'description' => 'Add modules',
                'type'        => 'write',
		'services' => array('moodle_mobile_app'),
        ),
	'local_modulews_edit_folder_files' => array(
                'classname'   => 'local_modulews_external',
                'methodname'  => 'edit_folder_files',
                'classpath'   => 'local/modulews/externallib.php',
                'description' => 'Edit folder file',
                'type'        => 'write',
		'services' => array('moodle_mobile_app'),
        ),
	'local_modulews_edit_folder_name_module' => array(
                'classname'   => 'local_modulews_external',
                'methodname'  => 'edit_folder_name_module',
                'classpath'   => 'local/modulews/externallib.php',
                'description' => 'Edit name module',
                'type'        => 'write',
		'services' => array('moodle_mobile_app'),
        ),
	'local_modulews_add_section_course' => array(
                'classname'   => 'local_modulews_external',
                'methodname'  => 'add_section_course',
                'classpath'   => 'local/modulews/externallib.php',
                'description' => 'Add section to course',
                'type'        => 'write',
		'services' => array('moodle_mobile_app'),
        ),
	'local_modulews_remove_folder_module_course' => array(
                'classname'   => 'local_modulews_external',
                'methodname'  => 'remove_folder_module_course',
                'classpath'   => 'local/modulews/externallib.php',
                'description' => 'Remove module by id in course',
                'type'        => 'write',
		'services' => array('moodle_mobile_app'),
        ),
	'local_modulews_update_note' => array(
                'classname'   => 'local_modulews_external',
                'methodname'  => 'update_notes',
                'classpath'   => 'local/modulews/externallib.php',
                'description' => 'Update note exist in course',
                'type'        => 'write',
		'services' => array('moodle_mobile_app'),
        ),
	'local_modulews_edit_assign' => array(
                'classname'   => 'local_modulews_external',
                'methodname'  => 'edit_assign',
                'classpath'   => 'local/modulews/externallib.php',
                'description' => 'Update assignment in course',
                'type'        => 'write',
		'services' => array('moodle_mobile_app'),
        ),
	'local_modulews_review_quiz' => array(
                'classname'   => 'local_modulews_external',
                'methodname'  => 'review_quiz',
                'classpath'   => 'local/modulews/externallib.php',
                'description' => 'Review latest attempt of a quiz',
                'type'        => 'write',
		'services' => array('moodle_mobile_app'),
        ),
	'local_modulews_quiz_set_grades' => array(
                'classname'   => 'local_modulews_external',
                'methodname'  => 'quiz_set_grades',
                'classpath'   => 'local/modulews/externallib.php',
                'description' => 'Update quiz grade',
                'type'        => 'write',
		'services' => array('moodle_mobile_app'),
        )

);
