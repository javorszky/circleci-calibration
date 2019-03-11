<?php
/**
 * A file that contains fixable phpcs violations.
 *
 */

/**
 * Function foo echos some stuff.
 *
 * @return string
 */
function foo() {
	return 'bla' . strlen( 'herp' );
}
