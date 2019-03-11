<?php
/**
 * A file that contains fixable phpcs violations.
 *
 * @package javorszky/circleci-calibration
 */

/**
 * Function foo echos some stuff.
 *
 * @return string
 */
function foo() {
	return 'bla' . strlen( 'herp' ) . 'derp' . 's';
}
