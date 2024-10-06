// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_hashing.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetImageEntryCollection on Isar {
  IsarCollection<ImageEntry> get imageEntrys => this.collection();
}

const ImageEntrySchema = CollectionSchema(
  name: r'ImageEntry',
  id: 5689366924663430712,
  properties: {
    r'bitDepth': PropertySchema(
      id: 0,
      name: r'bitDepth',
      type: IsarType.long,
    ),
    r'fileSize': PropertySchema(
      id: 1,
      name: r'fileSize',
      type: IsarType.long,
    ),
    r'hash': PropertySchema(
      id: 2,
      name: r'hash',
      type: IsarType.longList,
    ),
    r'height': PropertySchema(
      id: 3,
      name: r'height',
      type: IsarType.long,
    ),
    r'imagePath': PropertySchema(
      id: 4,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'lastModified': PropertySchema(
      id: 5,
      name: r'lastModified',
      type: IsarType.dateTime,
    ),
    r'width': PropertySchema(
      id: 6,
      name: r'width',
      type: IsarType.long,
    )
  },
  estimateSize: _imageEntryEstimateSize,
  serialize: _imageEntrySerialize,
  deserialize: _imageEntryDeserialize,
  deserializeProp: _imageEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'imagePath': IndexSchema(
      id: -9175562939963215800,
      name: r'imagePath',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'imagePath',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _imageEntryGetId,
  getLinks: _imageEntryGetLinks,
  attach: _imageEntryAttach,
  version: '3.1.0+1',
);

int _imageEntryEstimateSize(
  ImageEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.hash.length * 8;
  bytesCount += 3 + object.imagePath.length * 3;
  return bytesCount;
}

void _imageEntrySerialize(
  ImageEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bitDepth);
  writer.writeLong(offsets[1], object.fileSize);
  writer.writeLongList(offsets[2], object.hash);
  writer.writeLong(offsets[3], object.height);
  writer.writeString(offsets[4], object.imagePath);
  writer.writeDateTime(offsets[5], object.lastModified);
  writer.writeLong(offsets[6], object.width);
}

ImageEntry _imageEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ImageEntry();
  object.bitDepth = reader.readLong(offsets[0]);
  object.fileSize = reader.readLong(offsets[1]);
  object.hash = reader.readLongList(offsets[2]) ?? [];
  object.height = reader.readLong(offsets[3]);
  object.id = id;
  object.imagePath = reader.readString(offsets[4]);
  object.lastModified = reader.readDateTime(offsets[5]);
  object.width = reader.readLong(offsets[6]);
  return object;
}

P _imageEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongList(offset) ?? []) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _imageEntryGetId(ImageEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _imageEntryGetLinks(ImageEntry object) {
  return [];
}

void _imageEntryAttach(IsarCollection<dynamic> col, Id id, ImageEntry object) {
  object.id = id;
}

extension ImageEntryQueryWhereSort
    on QueryBuilder<ImageEntry, ImageEntry, QWhere> {
  QueryBuilder<ImageEntry, ImageEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ImageEntryQueryWhere
    on QueryBuilder<ImageEntry, ImageEntry, QWhereClause> {
  QueryBuilder<ImageEntry, ImageEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterWhereClause> imagePathEqualTo(
      String imagePath) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'imagePath',
        value: [imagePath],
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterWhereClause> imagePathNotEqualTo(
      String imagePath) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'imagePath',
              lower: [],
              upper: [imagePath],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'imagePath',
              lower: [imagePath],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'imagePath',
              lower: [imagePath],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'imagePath',
              lower: [],
              upper: [imagePath],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ImageEntryQueryFilter
    on QueryBuilder<ImageEntry, ImageEntry, QFilterCondition> {
  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> bitDepthEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bitDepth',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      bitDepthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bitDepth',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> bitDepthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bitDepth',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> bitDepthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bitDepth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> fileSizeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileSize',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      fileSizeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fileSize',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> fileSizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fileSize',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> fileSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fileSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      hashElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hash',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      hashElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hash',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      hashElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hash',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      hashElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> hashLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hash',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> hashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hash',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> hashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hash',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      hashLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hash',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      hashLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hash',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> hashLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hash',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> heightEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> heightGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> heightLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> heightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> imagePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      imagePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> imagePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> imagePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> imagePathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> imagePathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      lastModifiedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastModified',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      lastModifiedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastModified',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      lastModifiedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastModified',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition>
      lastModifiedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastModified',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> widthEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> widthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> widthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterFilterCondition> widthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'width',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ImageEntryQueryObject
    on QueryBuilder<ImageEntry, ImageEntry, QFilterCondition> {}

extension ImageEntryQueryLinks
    on QueryBuilder<ImageEntry, ImageEntry, QFilterCondition> {}

extension ImageEntryQuerySortBy
    on QueryBuilder<ImageEntry, ImageEntry, QSortBy> {
  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> sortByBitDepth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bitDepth', Sort.asc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> sortByBitDepthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bitDepth', Sort.desc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> sortByFileSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileSize', Sort.asc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> sortByFileSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileSize', Sort.desc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> sortByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> sortByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> sortByLastModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.asc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> sortByLastModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.desc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> sortByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> sortByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension ImageEntryQuerySortThenBy
    on QueryBuilder<ImageEntry, ImageEntry, QSortThenBy> {
  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenByBitDepth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bitDepth', Sort.asc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenByBitDepthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bitDepth', Sort.desc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenByFileSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileSize', Sort.asc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenByFileSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileSize', Sort.desc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenByLastModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.asc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenByLastModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.desc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QAfterSortBy> thenByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension ImageEntryQueryWhereDistinct
    on QueryBuilder<ImageEntry, ImageEntry, QDistinct> {
  QueryBuilder<ImageEntry, ImageEntry, QDistinct> distinctByBitDepth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bitDepth');
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QDistinct> distinctByFileSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileSize');
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QDistinct> distinctByHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hash');
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QDistinct> distinctByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'height');
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QDistinct> distinctByLastModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastModified');
    });
  }

  QueryBuilder<ImageEntry, ImageEntry, QDistinct> distinctByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'width');
    });
  }
}

extension ImageEntryQueryProperty
    on QueryBuilder<ImageEntry, ImageEntry, QQueryProperty> {
  QueryBuilder<ImageEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ImageEntry, int, QQueryOperations> bitDepthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bitDepth');
    });
  }

  QueryBuilder<ImageEntry, int, QQueryOperations> fileSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileSize');
    });
  }

  QueryBuilder<ImageEntry, List<int>, QQueryOperations> hashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hash');
    });
  }

  QueryBuilder<ImageEntry, int, QQueryOperations> heightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'height');
    });
  }

  QueryBuilder<ImageEntry, String, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<ImageEntry, DateTime, QQueryOperations> lastModifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastModified');
    });
  }

  QueryBuilder<ImageEntry, int, QQueryOperations> widthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'width');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetImageSimilarityCollection on Isar {
  IsarCollection<ImageSimilarity> get imageSimilaritys => this.collection();
}

const ImageSimilaritySchema = CollectionSchema(
  name: r'ImageSimilarity',
  id: 6138389675804802505,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'similarity': PropertySchema(
      id: 1,
      name: r'similarity',
      type: IsarType.double,
    )
  },
  estimateSize: _imageSimilarityEstimateSize,
  serialize: _imageSimilaritySerialize,
  deserialize: _imageSimilarityDeserialize,
  deserializeProp: _imageSimilarityDeserializeProp,
  idName: r'id',
  indexes: {
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'image1': LinkSchema(
      id: -3761517999485678913,
      name: r'image1',
      target: r'ImageEntry',
      single: true,
    ),
    r'image2': LinkSchema(
      id: -2180509875577631171,
      name: r'image2',
      target: r'ImageEntry',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _imageSimilarityGetId,
  getLinks: _imageSimilarityGetLinks,
  attach: _imageSimilarityAttach,
  version: '3.1.0+1',
);

int _imageSimilarityEstimateSize(
  ImageSimilarity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _imageSimilaritySerialize(
  ImageSimilarity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDouble(offsets[1], object.similarity);
}

ImageSimilarity _imageSimilarityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ImageSimilarity();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.similarity = reader.readDouble(offsets[1]);
  return object;
}

P _imageSimilarityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _imageSimilarityGetId(ImageSimilarity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _imageSimilarityGetLinks(ImageSimilarity object) {
  return [object.image1, object.image2];
}

void _imageSimilarityAttach(
    IsarCollection<dynamic> col, Id id, ImageSimilarity object) {
  object.id = id;
  object.image1.attach(col, col.isar.collection<ImageEntry>(), r'image1', id);
  object.image2.attach(col, col.isar.collection<ImageEntry>(), r'image2', id);
}

extension ImageSimilarityQueryWhereSort
    on QueryBuilder<ImageSimilarity, ImageSimilarity, QWhere> {
  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension ImageSimilarityQueryWhere
    on QueryBuilder<ImageSimilarity, ImageSimilarity, QWhereClause> {
  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterWhereClause>
      createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterWhereClause>
      createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ImageSimilarityQueryFilter
    on QueryBuilder<ImageSimilarity, ImageSimilarity, QFilterCondition> {
  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      similarityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'similarity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      similarityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'similarity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      similarityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'similarity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      similarityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'similarity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension ImageSimilarityQueryObject
    on QueryBuilder<ImageSimilarity, ImageSimilarity, QFilterCondition> {}

extension ImageSimilarityQueryLinks
    on QueryBuilder<ImageSimilarity, ImageSimilarity, QFilterCondition> {
  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition> image1(
      FilterQuery<ImageEntry> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'image1');
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      image1IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'image1', 0, true, 0, true);
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition> image2(
      FilterQuery<ImageEntry> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'image2');
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterFilterCondition>
      image2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'image2', 0, true, 0, true);
    });
  }
}

extension ImageSimilarityQuerySortBy
    on QueryBuilder<ImageSimilarity, ImageSimilarity, QSortBy> {
  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterSortBy>
      sortBySimilarity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'similarity', Sort.asc);
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterSortBy>
      sortBySimilarityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'similarity', Sort.desc);
    });
  }
}

extension ImageSimilarityQuerySortThenBy
    on QueryBuilder<ImageSimilarity, ImageSimilarity, QSortThenBy> {
  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterSortBy>
      thenBySimilarity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'similarity', Sort.asc);
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QAfterSortBy>
      thenBySimilarityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'similarity', Sort.desc);
    });
  }
}

extension ImageSimilarityQueryWhereDistinct
    on QueryBuilder<ImageSimilarity, ImageSimilarity, QDistinct> {
  QueryBuilder<ImageSimilarity, ImageSimilarity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ImageSimilarity, ImageSimilarity, QDistinct>
      distinctBySimilarity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'similarity');
    });
  }
}

extension ImageSimilarityQueryProperty
    on QueryBuilder<ImageSimilarity, ImageSimilarity, QQueryProperty> {
  QueryBuilder<ImageSimilarity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ImageSimilarity, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ImageSimilarity, double, QQueryOperations> similarityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'similarity');
    });
  }
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$similaritiesWatcherHash() =>
    r'dfb25d4876fd6d599c195abee05f69fb089cd151';

/// See also [similaritiesWatcher].
@ProviderFor(similaritiesWatcher)
final similaritiesWatcherProvider = AutoDisposeStreamProvider<void>.internal(
  similaritiesWatcher,
  name: r'similaritiesWatcherProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$similaritiesWatcherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SimilaritiesWatcherRef = AutoDisposeStreamProviderRef<void>;
String _$similaritiesCountHash() => r'fab18ad6ee13035cf6e652def889e90e67f7deb7';

/// See also [similaritiesCount].
@ProviderFor(similaritiesCount)
final similaritiesCountProvider = AutoDisposeFutureProvider<int>.internal(
  similaritiesCount,
  name: r'similaritiesCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$similaritiesCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SimilaritiesCountRef = AutoDisposeFutureProviderRef<int>;
String _$hashingSystemHash() => r'54a12a178b500eab30fd78935a466c583fc9bd5b';

/// See also [HashingSystem].
@ProviderFor(HashingSystem)
final hashingSystemProvider =
    AsyncNotifierProvider<HashingSystem, ImageHashSystem>.internal(
  HashingSystem.new,
  name: r'hashingSystemProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hashingSystemHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HashingSystem = AsyncNotifier<ImageHashSystem>;
String _$comparisonControllerHash() =>
    r'e2893d5389e26ac20016188b152116fe4e0e78e2';

/// See also [ComparisonController].
@ProviderFor(ComparisonController)
final comparisonControllerProvider =
    AsyncNotifierProvider<ComparisonController, ComparisonType?>.internal(
  ComparisonController.new,
  name: r'comparisonControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$comparisonControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ComparisonController = AsyncNotifier<ComparisonType?>;
String _$similaritiesQueryHash() => r'4ef53c878fbd34d70b0c931f63498c1bd0b99b9f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SimilaritiesQuery
    extends BuildlessAutoDisposeAsyncNotifier<List<ImageSimilarity>> {
  late final int? limit;
  late final int? offset;

  FutureOr<List<ImageSimilarity>> build({
    int? limit,
    int? offset,
  });
}

/// See also [SimilaritiesQuery].
@ProviderFor(SimilaritiesQuery)
const similaritiesQueryProvider = SimilaritiesQueryFamily();

/// See also [SimilaritiesQuery].
class SimilaritiesQueryFamily
    extends Family<AsyncValue<List<ImageSimilarity>>> {
  /// See also [SimilaritiesQuery].
  const SimilaritiesQueryFamily();

  /// See also [SimilaritiesQuery].
  SimilaritiesQueryProvider call({
    int? limit,
    int? offset,
  }) {
    return SimilaritiesQueryProvider(
      limit: limit,
      offset: offset,
    );
  }

  @override
  SimilaritiesQueryProvider getProviderOverride(
    covariant SimilaritiesQueryProvider provider,
  ) {
    return call(
      limit: provider.limit,
      offset: provider.offset,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'similaritiesQueryProvider';
}

/// See also [SimilaritiesQuery].
class SimilaritiesQueryProvider extends AutoDisposeAsyncNotifierProviderImpl<
    SimilaritiesQuery, List<ImageSimilarity>> {
  /// See also [SimilaritiesQuery].
  SimilaritiesQueryProvider({
    int? limit,
    int? offset,
  }) : this._internal(
          () => SimilaritiesQuery()
            ..limit = limit
            ..offset = offset,
          from: similaritiesQueryProvider,
          name: r'similaritiesQueryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$similaritiesQueryHash,
          dependencies: SimilaritiesQueryFamily._dependencies,
          allTransitiveDependencies:
              SimilaritiesQueryFamily._allTransitiveDependencies,
          limit: limit,
          offset: offset,
        );

  SimilaritiesQueryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
    required this.offset,
  }) : super.internal();

  final int? limit;
  final int? offset;

  @override
  FutureOr<List<ImageSimilarity>> runNotifierBuild(
    covariant SimilaritiesQuery notifier,
  ) {
    return notifier.build(
      limit: limit,
      offset: offset,
    );
  }

  @override
  Override overrideWith(SimilaritiesQuery Function() create) {
    return ProviderOverride(
      origin: this,
      override: SimilaritiesQueryProvider._internal(
        () => create()
          ..limit = limit
          ..offset = offset,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SimilaritiesQuery,
      List<ImageSimilarity>> createElement() {
    return _SimilaritiesQueryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SimilaritiesQueryProvider &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SimilaritiesQueryRef
    on AutoDisposeAsyncNotifierProviderRef<List<ImageSimilarity>> {
  /// The parameter `limit` of this provider.
  int? get limit;

  /// The parameter `offset` of this provider.
  int? get offset;
}

class _SimilaritiesQueryProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SimilaritiesQuery,
        List<ImageSimilarity>> with SimilaritiesQueryRef {
  _SimilaritiesQueryProviderElement(super.provider);

  @override
  int? get limit => (origin as SimilaritiesQueryProvider).limit;
  @override
  int? get offset => (origin as SimilaritiesQueryProvider).offset;
}

String _$fileOpsControllerHash() => r'e9f72a7d04411be05931c93a922ed8b9902f2be5';

/// See also [FileOpsController].
@ProviderFor(FileOpsController)
final fileOpsControllerProvider =
    AutoDisposeAsyncNotifierProvider<FileOpsController, void>.internal(
  FileOpsController.new,
  name: r'fileOpsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fileOpsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FileOpsController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
