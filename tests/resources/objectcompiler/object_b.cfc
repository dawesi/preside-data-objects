/**
 * @labelfield code
 *
 */
component {
	property name="label" maxlength=255;
	property name="code" type="string" dbtype="varchar" maxlength=50 required=true;

	public boolean function testMethodsWorking() {
		return false;
	}
}