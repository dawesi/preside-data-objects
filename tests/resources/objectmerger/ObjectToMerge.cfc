component {
	public boolean function methodOverridden() {
		return true;
	}

	public boolean function newMethodSuccessfullyCallingPrivateMethod(){
		return _privateMethodCall();
	}

	private boolean function _privateMethodCall() {
		return true;
	}
}