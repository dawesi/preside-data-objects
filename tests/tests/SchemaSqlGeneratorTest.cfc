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
				var property  = { name="test", type="boolean", dbtype="boolean", required=false };
				var mockSql   = CreateUUId();

				mockDbAdapter.$( "getColumnDefinitionSql" ).$args(
					  columnName    = property.name
					, dbType        = property.dbType
					, maxLength     = 0
					, nullable      = !property.required
					, primaryKey    = false
					, autoIncrement = false
				).$results( mockSql );

				expect( generator.getColumnDefinitionSql( property=property ) ).toBe( mockSql );
			} );
		} );
	}

/*********************************** PRIVATE HELPERS ***********************************/
	private function _getGenerator() {
		variables.mockDbAdapter = getMockBox().createEmptyMock( "presidedataobjects.db.adapter.MySqlAdapter" );

		return getMockBox().createMock(
			object = new presidedataobjects.db.schema.SchemaSqlGenerator(
				dbAdapter = mockDbAdapter
			)
		);
	}
}
