component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
	}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "getColumnDefinitionSqlFromObjectProperty()", function(){
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

				expect( generator.getColumnDefinitionSqlFromObjectProperty( property=property ) ).toBe( mockSql );
			} );

			it( "should return pass primary key and auto increment arguments correctly when they are specified on the property", function(){
				var generator = _getGenerator();
				var property  = { name="test", type="string", dbtype="varchar", maxLength=39, required=true, pk=true, generator="increment" };
				var mockSql   = CreateUUId();

				mockDbAdapter.$( "getColumnDefinitionSql" ).$args(
					  columnName    = property.name
					, dbType        = property.dbType
					, maxLength     = property.maxLength
					, nullable      = !property.required
					, primaryKey    = true
					, autoIncrement = true
				).$results( mockSql );

				expect( generator.getColumnDefinitionSqlFromObjectProperty( property=property ) ).toBe( mockSql );
			} );
		} );

		describe( "getCreateTableSqlFromObject()", function(){
			it( "should return a create table statement around column definitions for each of the objects properties", function(){
				var mockObj       = getMockBox().createStub();
				var generator     = _getGenerator();
				var dummySql      = CreateUUId();
				var properties    = StructNew( "linked" );
				var mockTablename = CreateUUId();
				var columnDefs    = [];

				properties[ "propa" ] = { test=CreateUUId(), sql=CreateUUId() };
				properties[ "propb" ] = { test=CreateUUId(), sql=CreateUUId() };
				properties[ "propc" ] = { test=CreateUUId(), sql=CreateUUId() };
				properties[ "propd" ] = { test=CreateUUId(), sql=CreateUUId() };

				mockObj.$( "getTablename", mockTablename );
				mockObj.$( "listProperties", properties.keyArray() );
				for( var propName in properties ) {
					mockObj.$( "getProperty" ).$args( propertyName=propName ).$results( properties[ propName ] );
					generator.$( "getColumnDefinitionSqlFromObjectProperty" ).$args( property=properties[ propName ] ).$results( properties[ propName ].sql );
					columnDefs.append( properties[ propName ].sql );
				}

				mockDbAdapter.$( "getTableDefinitionSql" ).$args( tableName=mockTablename, columnDefinitions=columnDefs ).$results( dummySql );

				expect( generator.getCreateTableSqlFromObject( mockObj ) ).toBe( dummySql );
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
