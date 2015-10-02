component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
	}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "getColumnDefinitionSql", function(){
			it( "should return a column definition sql string for the given preside object property", function(){
				var generator = _getGenerator();

				fail( "not yet implemented" );
			} );
		} );
	}

/*********************************** PRIVATE HELPERS ***********************************/
	private function _getGenerator() {
		return getMockBox().createMock(
			object = new presidedataobjects.db.schema.SchemaSqlGenerator()
		);
	}
}
