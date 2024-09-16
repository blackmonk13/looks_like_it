// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'similar_image.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSimilarImageCollection on Isar {
  IsarCollection<SimilarImage> get similarImages => this.collection();
}

const SimilarImageSchema = CollectionSchema(
  name: r'SimilarImage',
  id: -4459735017059265948,
  properties: {
    r'height': PropertySchema(
      id: 0,
      name: r'height',
      type: IsarType.long,
    ),
    r'imageHash': PropertySchema(
      id: 1,
      name: r'imageHash',
      type: IsarType.string,
    ),
    r'imagePath': PropertySchema(
      id: 2,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'size': PropertySchema(
      id: 3,
      name: r'size',
      type: IsarType.string,
    ),
    r'width': PropertySchema(
      id: 4,
      name: r'width',
      type: IsarType.long,
    )
  },
  estimateSize: _similarImageEstimateSize,
  serialize: _similarImageSerialize,
  deserialize: _similarImageDeserialize,
  deserializeProp: _similarImageDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'similarities': LinkSchema(
      id: -4662441596162396127,
      name: r'similarities',
      target: r'SimilarImage',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _similarImageGetId,
  getLinks: _similarImageGetLinks,
  attach: _similarImageAttach,
  version: '3.1.0+1',
);

int _similarImageEstimateSize(
  SimilarImage object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.imageHash.length * 3;
  bytesCount += 3 + object.imagePath.length * 3;
  bytesCount += 3 + object.size.length * 3;
  return bytesCount;
}

void _similarImageSerialize(
  SimilarImage object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.height);
  writer.writeString(offsets[1], object.imageHash);
  writer.writeString(offsets[2], object.imagePath);
  writer.writeString(offsets[3], object.size);
  writer.writeLong(offsets[4], object.width);
}

SimilarImage _similarImageDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SimilarImage(
    height: reader.readLong(offsets[0]),
    imageHash: reader.readString(offsets[1]),
    imagePath: reader.readString(offsets[2]),
    size: reader.readString(offsets[3]),
    width: reader.readLong(offsets[4]),
  );
  object.id = id;
  return object;
}

P _similarImageDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _similarImageGetId(SimilarImage object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _similarImageGetLinks(SimilarImage object) {
  return [object.similarities];
}

void _similarImageAttach(
    IsarCollection<dynamic> col, Id id, SimilarImage object) {
  object.id = id;
  object.similarities
      .attach(col, col.isar.collection<SimilarImage>(), r'similarities', id);
}

extension SimilarImageQueryWhereSort
    on QueryBuilder<SimilarImage, SimilarImage, QWhere> {
  QueryBuilder<SimilarImage, SimilarImage, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SimilarImageQueryWhere
    on QueryBuilder<SimilarImage, SimilarImage, QWhereClause> {
  QueryBuilder<SimilarImage, SimilarImage, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterWhereClause> idBetween(
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
}

extension SimilarImageQueryFilter
    on QueryBuilder<SimilarImage, SimilarImage, QFilterCondition> {
  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> heightEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      heightGreaterThan(
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      heightLessThan(
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> heightBetween(
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imageHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imageHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imageHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imageHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imageHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imageHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imageHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imageHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imageHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageHash',
        value: '',
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imageHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageHash',
        value: '',
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imagePathEqualTo(
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imagePathLessThan(
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imagePathBetween(
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imagePathEndsWith(
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> sizeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'size',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      sizeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'size',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> sizeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'size',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> sizeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'size',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      sizeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'size',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> sizeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'size',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> sizeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'size',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> sizeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'size',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      sizeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'size',
        value: '',
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      sizeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'size',
        value: '',
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> widthEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      widthGreaterThan(
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> widthLessThan(
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

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> widthBetween(
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

extension SimilarImageQueryObject
    on QueryBuilder<SimilarImage, SimilarImage, QFilterCondition> {}

extension SimilarImageQueryLinks
    on QueryBuilder<SimilarImage, SimilarImage, QFilterCondition> {
  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition> similarities(
      FilterQuery<SimilarImage> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'similarities');
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      similaritiesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'similarities', length, true, length, true);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      similaritiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'similarities', 0, true, 0, true);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      similaritiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'similarities', 0, false, 999999, true);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      similaritiesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'similarities', 0, true, length, include);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      similaritiesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'similarities', length, include, 999999, true);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterFilterCondition>
      similaritiesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'similarities', lower, includeLower, upper, includeUpper);
    });
  }
}

extension SimilarImageQuerySortBy
    on QueryBuilder<SimilarImage, SimilarImage, QSortBy> {
  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> sortByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> sortByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> sortByImageHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageHash', Sort.asc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> sortByImageHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageHash', Sort.desc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> sortBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.asc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> sortBySizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.desc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> sortByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> sortByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension SimilarImageQuerySortThenBy
    on QueryBuilder<SimilarImage, SimilarImage, QSortThenBy> {
  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> thenByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> thenByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> thenByImageHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageHash', Sort.asc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> thenByImageHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageHash', Sort.desc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> thenBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.asc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> thenBySizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.desc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> thenByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QAfterSortBy> thenByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension SimilarImageQueryWhereDistinct
    on QueryBuilder<SimilarImage, SimilarImage, QDistinct> {
  QueryBuilder<SimilarImage, SimilarImage, QDistinct> distinctByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'height');
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QDistinct> distinctByImageHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QDistinct> distinctBySize(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'size', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SimilarImage, SimilarImage, QDistinct> distinctByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'width');
    });
  }
}

extension SimilarImageQueryProperty
    on QueryBuilder<SimilarImage, SimilarImage, QQueryProperty> {
  QueryBuilder<SimilarImage, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SimilarImage, int, QQueryOperations> heightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'height');
    });
  }

  QueryBuilder<SimilarImage, String, QQueryOperations> imageHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageHash');
    });
  }

  QueryBuilder<SimilarImage, String, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<SimilarImage, String, QQueryOperations> sizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'size');
    });
  }

  QueryBuilder<SimilarImage, int, QQueryOperations> widthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'width');
    });
  }
}
