component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		variables.testDsn = "anyolddsn";
	}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "getDatabaseVersion()", function(){
			it( "should return result from dbinfo type='version' call ", function(){
				var service     = _getInfoService();
				var dummyResult = QueryNew( 'test', 'varchar', [[ CreateUUId() ]] );

				service.$( "_dbInfo" ).$args( datasource=testDsn, type="version" ).$results( dummyResult );

				expect( service.getDatabaseVersion( dsn=testDsn ) ).toBe( dummyResult );
			} );
		} );

		describe( "listTables", function(){
			it( "should return result of call to dbinfo type='tables' converted to array of names", function(){
				var service        = _getInfoService();
				var dummyRecordset = QueryNew( "table_name", "varchar", [
					  [ "table_1"]
					, [ "table_2"]
					, [ "table_3"]
					, [ "table_4"]
					, [ "table_5"]
				] );
				var expected = [ "table_1", "table_2", "table_3", "table_4", "table_5" ];

				service.$( "_dbInfo" ).$args( datasource=testDsn, type="tables" ).$results( dummyRecordset );

				expect( service.listTables( dsn=testDsn ) ).toBe( expected );
			} );
		} );

		describe( "tableExists()", function(){
			it( "should return false when table is not found in list of tables from listTables()", function(){
				var service   = _getInfoService();
				var tablename = CreateUUId();

				service.$( "listTables" ).$args( dsn=testDsn ).$results( [ CreateUUId(), CreateUUId(), CreateUUId() ] );

				expect( service.tableExists( tablename=tablename, dsn=testDsn ) ).toBe( false );
			} );

			it( "should return true when table is found in list of tables from listTables()", function(){
				var service   = _getInfoService();
				var tablename = CreateUUId();

				service.$( "listTables" ).$args( dsn=testDsn ).$results( [ CreateUUId(), tablename, CreateUUId() ] );

				expect( service.tableExists( tablename=tablename, dsn=testDsn ) ).toBe( true );
			} );

		} );

		describe( "getTableInfo()", function(){
			it( "should return result of call to dbinfo type='tables' filtered by the passed tablename", function(){
				var service     = _getInfoService();
				var dummyResult = QueryNew( 'test', 'varchar', [[ CreateUUId() ]] );
				var tableName   = CreateUUId();

				service.$( "_dbInfo" ).$args( datasource=testDsn, type="tables", pattern=tableName ).$results( dummyResult );

				expect( service.getTableInfo( dsn=testDsn, tableName=tableName ) ).toBe( dummyResult );
			} );
		} );

		describe( "getTableColumns()", function(){
			it( "should return result of call to dbinfo type='columns' filtered by the passed tablename", function(){
				var service     = _getInfoService();
				var dummyResult = QueryNew( 'test', 'varchar', [[ CreateUUId() ]] );
				var tableName   = CreateUUId();

				service.$( "_dbInfo" ).$args( datasource=testDsn, type="columns", table=tableName ).$results( dummyResult );

				expect( service.getTableColumns( dsn=testDsn, tableName=tableName ) ).toBe( dummyResult );
			} );
		} );

		describe( "getTableIndexes", function(){
			it( "should return result of call to dbinfo type='index' filtered by the passed tablename, reformatted into a useful structure and excluding the primary key", function(){
				var service     = _getInfoService();
				var tableName   = CreateUUId();
				var dummyResult = QueryNew( 'non_unique,index_name,column_name', 'varchar,varchar,varchar', [
					  [ "false", "PRIMARY" , "id" ]
					, [ "false", "ux_one"  , "fielda" ]
					, [ "false", "ux_one"  , "fieldb" ]
					, [ "true" , "ix_two"  , "fielda" ]
					, [ "true" , "ix_two"  , "fieldb" ]
					, [ "true" , "ix_two"  , "fieldc" ]
					, [ "true" , "ix_three", "fielda" ]
				] );
				var expectedConversion = {
					  ux_one   = { unique=true , fields=[ "fielda", "fieldb" ] }
					, ix_two   = { unique=false, fields=[ "fielda", "fieldb", "fieldc" ] }
					, ix_three = { unique=false, fields=[ "fielda" ] }
				};

				service.$( "_dbInfo" ).$args( datasource=testDsn, type="index", table=tableName ).$results( dummyResult );

				expect( service.getTableIndexes( dsn=testDsn, tableName=tableName ) ).toBe( expectedConversion );
			} );
		} );
	}


/*********************************** PRIVATE HELPERS ***********************************/
	private any function _getInfoService() {
		var service = new presidedataobjects.db.DbInfoService();

		return getMockbox().createMock( object=service );
	}

}