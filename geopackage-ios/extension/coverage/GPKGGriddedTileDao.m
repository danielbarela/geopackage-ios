//
//  GPKGGriddedTileDao.m
//  geopackage-ios
//
//  Created by Brian Osborn on 11/11/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import "GPKGGriddedTileDao.h"
#import "GPKGContentsDao.h"
#import "GPKGUtils.h"

@implementation GPKGGriddedTileDao

-(instancetype) initWithDatabase: (GPKGConnection *) database{
    self = [super initWithDatabase:database];
    if(self != nil){
        self.tableName = GPKG_CDGT_TABLE_NAME;
        self.idColumns = @[GPKG_CDGT_COLUMN_PK];
        self.columns = @[GPKG_CDGT_COLUMN_ID, GPKG_CDGT_COLUMN_TABLE_NAME, GPKG_CDGT_COLUMN_TABLE_ID, GPKG_CDGT_COLUMN_SCALE, GPKG_CDGT_COLUMN_OFFSET, GPKG_CDGT_COLUMN_MIN, GPKG_CDGT_COLUMN_MAX, GPKG_CDGT_COLUMN_MEAN, GPKG_CDGT_COLUMN_STANDARD_DEVIATION];
        [self initializeColumnIndex];
    }
    return self;
}

-(NSObject *) createObject{
    return [[GPKGGriddedTile alloc] init];
}

-(void) setValueInObject: (NSObject*) object withColumnIndex: (int) columnIndex withValue: (NSObject *) value{
    
    GPKGGriddedTile *setObject = (GPKGGriddedTile*) object;
    
    switch(columnIndex){
        case 0:
            setObject.id = (NSNumber *) value;
            break;
        case 1:
            setObject.tableName = (NSString *) value;
            break;
        case 2:
            setObject.tableId = (NSNumber *) value;
            break;
        case 3:
            setObject.scale = [GPKGUtils decimalNumberFromNumber:(NSNumber *) value];
            break;
        case 4:
            setObject.offset = [GPKGUtils decimalNumberFromNumber:(NSNumber *) value];
            break;
        case 5:
            setObject.min = [GPKGUtils decimalNumberFromNumber:(NSNumber *) value];
            break;
        case 6:
            setObject.max = [GPKGUtils decimalNumberFromNumber:(NSNumber *) value];
            break;
        case 7:
            setObject.mean = [GPKGUtils decimalNumberFromNumber:(NSNumber *) value];
            break;
        case 8:
            setObject.standardDeviation = [GPKGUtils decimalNumberFromNumber:(NSNumber *) value];
            break;
        default:
            [NSException raise:@"Illegal Column Index" format:@"Unsupported column index: %d", columnIndex];
            break;
    }
    
}

-(NSObject *) getValueFromObject: (NSObject*) object withColumnIndex: (int) columnIndex{
    
    NSObject * value = nil;
    
    GPKGGriddedTile *getObject = (GPKGGriddedTile*) object;
    
    switch(columnIndex){
        case 0:
            value = getObject.id;
            break;
        case 1:
            value = getObject.tableName;
            break;
        case 2:
            value = getObject.tableId;
            break;
        case 3:
            value = getObject.scale;
            break;
        case 4:
            value = getObject.offset;
            break;
        case 5:
            value = getObject.min;
            break;
        case 6:
            value = getObject.max;
            break;
        case 7:
            value = getObject.mean;
            break;
        case 8:
            value = getObject.standardDeviation;
            break;
        default:
            [NSException raise:@"Illegal Column Index" format:@"Unsupported column index: %d", columnIndex];
            break;
    }
    
    return value;
}

-(long long) insert: (NSObject *) object{
    long long id = [super insert:object];
    [self setId:object withIdValue:[NSNumber numberWithLongLong:id]];
    return id;
}

-(GPKGResultSet *) queryByContents: (GPKGContents *) contents{
    return [self queryByTableName:contents.tableName];
}

-(GPKGResultSet *) queryByTableName: (NSString *) tableName{
    GPKGResultSet * results = [self queryForEqWithField:GPKG_CDGT_COLUMN_TABLE_NAME andValue:tableName];
    return results;
}

-(GPKGGriddedTile *) queryByTableName: (NSString *) tableName andTileId :(int) tileId{
    
    GPKGColumnValues *whereValues = [[GPKGColumnValues alloc] init];
    [whereValues addColumn:GPKG_CDGT_COLUMN_TABLE_NAME withValue:tableName];
    [whereValues addColumn:GPKG_CDGT_COLUMN_TABLE_ID withValue:[NSNumber numberWithInt:tileId]];
    
    NSString * where = [self buildWhereWithFields:whereValues];
    NSArray * whereArgs = [self buildWhereArgsWithValues:whereValues];
    
    GPKGResultSet * results = [self queryWhere:where andWhereArgs:whereArgs];
    GPKGGriddedTile * griddedTile = (GPKGGriddedTile *)[self getFirstObject:results];

    return griddedTile;
}

-(int) deleteByContents: (GPKGContents *) contents{
    return [self deleteByTileMatrixSetName:contents.tableName];
}

-(int) deleteByTileMatrixSetName: (NSString *) tableName{
    NSString * where = [self buildWhereWithField:GPKG_CDGT_COLUMN_TABLE_NAME andValue:tableName];
    NSArray * whereArgs = [self buildWhereArgsWithValue:tableName];
    int count = [self deleteWhere:where andWhereArgs:whereArgs];
    return count;
}

-(GPKGContents *) getContents: (GPKGGriddedTile *) griddedTile{
    GPKGContentsDao * dao = [self getContentsDao];
    GPKGContents *contents = (GPKGContents *)[dao queryForIdObject:griddedTile.tableName];
    return contents;
}

-(GPKGContentsDao *) getContentsDao{
    return [[GPKGContentsDao alloc] initWithDatabase:self.database];
}

@end
