// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarCourseInfoCollection on Isar {
  IsarCollection<IsarCourseInfo> get isarCourseInfos => this.collection();
}

const IsarCourseInfoSchema = CollectionSchema(
  name: r'IsarCourseInfo',
  id: -5635784993976964898,
  properties: {
    r'abbreviation': PropertySchema(
      id: 0,
      name: r'abbreviation',
      type: IsarType.string,
    ),
    r'classroom': PropertySchema(
      id: 1,
      name: r'classroom',
      type: IsarType.string,
    ),
    r'color': PropertySchema(
      id: 2,
      name: r'color',
      type: IsarType.string,
    ),
    r'courseId': PropertySchema(
      id: 3,
      name: r'courseId',
      type: IsarType.string,
    ),
    r'isOutdoor': PropertySchema(
      id: 4,
      name: r'isOutdoor',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'teacher': PropertySchema(
      id: 6,
      name: r'teacher',
      type: IsarType.string,
    )
  },
  estimateSize: _isarCourseInfoEstimateSize,
  serialize: _isarCourseInfoSerialize,
  deserialize: _isarCourseInfoDeserialize,
  deserializeProp: _isarCourseInfoDeserializeProp,
  idName: r'id',
  indexes: {
    r'courseId': IndexSchema(
      id: -4937057111615935929,
      name: r'courseId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'courseId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarCourseInfoGetId,
  getLinks: _isarCourseInfoGetLinks,
  attach: _isarCourseInfoAttach,
  version: '3.1.0+1',
);

int _isarCourseInfoEstimateSize(
  IsarCourseInfo object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.abbreviation.length * 3;
  bytesCount += 3 + object.classroom.length * 3;
  bytesCount += 3 + object.color.length * 3;
  bytesCount += 3 + object.courseId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.teacher.length * 3;
  return bytesCount;
}

void _isarCourseInfoSerialize(
  IsarCourseInfo object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.abbreviation);
  writer.writeString(offsets[1], object.classroom);
  writer.writeString(offsets[2], object.color);
  writer.writeString(offsets[3], object.courseId);
  writer.writeBool(offsets[4], object.isOutdoor);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.teacher);
}

IsarCourseInfo _isarCourseInfoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarCourseInfo();
  object.abbreviation = reader.readString(offsets[0]);
  object.classroom = reader.readString(offsets[1]);
  object.color = reader.readString(offsets[2]);
  object.courseId = reader.readString(offsets[3]);
  object.id = id;
  object.isOutdoor = reader.readBool(offsets[4]);
  object.name = reader.readString(offsets[5]);
  object.teacher = reader.readString(offsets[6]);
  return object;
}

P _isarCourseInfoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarCourseInfoGetId(IsarCourseInfo object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarCourseInfoGetLinks(IsarCourseInfo object) {
  return [];
}

void _isarCourseInfoAttach(
    IsarCollection<dynamic> col, Id id, IsarCourseInfo object) {
  object.id = id;
}

extension IsarCourseInfoByIndex on IsarCollection<IsarCourseInfo> {
  Future<IsarCourseInfo?> getByCourseId(String courseId) {
    return getByIndex(r'courseId', [courseId]);
  }

  IsarCourseInfo? getByCourseIdSync(String courseId) {
    return getByIndexSync(r'courseId', [courseId]);
  }

  Future<bool> deleteByCourseId(String courseId) {
    return deleteByIndex(r'courseId', [courseId]);
  }

  bool deleteByCourseIdSync(String courseId) {
    return deleteByIndexSync(r'courseId', [courseId]);
  }

  Future<List<IsarCourseInfo?>> getAllByCourseId(List<String> courseIdValues) {
    final values = courseIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'courseId', values);
  }

  List<IsarCourseInfo?> getAllByCourseIdSync(List<String> courseIdValues) {
    final values = courseIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'courseId', values);
  }

  Future<int> deleteAllByCourseId(List<String> courseIdValues) {
    final values = courseIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'courseId', values);
  }

  int deleteAllByCourseIdSync(List<String> courseIdValues) {
    final values = courseIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'courseId', values);
  }

  Future<Id> putByCourseId(IsarCourseInfo object) {
    return putByIndex(r'courseId', object);
  }

  Id putByCourseIdSync(IsarCourseInfo object, {bool saveLinks = true}) {
    return putByIndexSync(r'courseId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCourseId(List<IsarCourseInfo> objects) {
    return putAllByIndex(r'courseId', objects);
  }

  List<Id> putAllByCourseIdSync(List<IsarCourseInfo> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'courseId', objects, saveLinks: saveLinks);
  }
}

extension IsarCourseInfoQueryWhereSort
    on QueryBuilder<IsarCourseInfo, IsarCourseInfo, QWhere> {
  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarCourseInfoQueryWhere
    on QueryBuilder<IsarCourseInfo, IsarCourseInfo, QWhereClause> {
  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterWhereClause> idBetween(
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

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterWhereClause>
      courseIdEqualTo(String courseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'courseId',
        value: [courseId],
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterWhereClause>
      courseIdNotEqualTo(String courseId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'courseId',
              lower: [],
              upper: [courseId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'courseId',
              lower: [courseId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'courseId',
              lower: [courseId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'courseId',
              lower: [],
              upper: [courseId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarCourseInfoQueryFilter
    on QueryBuilder<IsarCourseInfo, IsarCourseInfo, QFilterCondition> {
  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      abbreviationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'abbreviation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      abbreviationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'abbreviation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      abbreviationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'abbreviation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      abbreviationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'abbreviation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      abbreviationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'abbreviation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      abbreviationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'abbreviation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      abbreviationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'abbreviation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      abbreviationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'abbreviation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      abbreviationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'abbreviation',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      abbreviationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'abbreviation',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      classroomEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'classroom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      classroomGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'classroom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      classroomLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'classroom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      classroomBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'classroom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      classroomStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'classroom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      classroomEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'classroom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      classroomContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'classroom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      classroomMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'classroom',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      classroomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'classroom',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      classroomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'classroom',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      colorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      colorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      colorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      colorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      colorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      colorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      colorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      colorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'color',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      colorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      colorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      courseIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      courseIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      courseIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      courseIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'courseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      courseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      courseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      courseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      courseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'courseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      courseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      courseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'courseId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
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

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
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

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition> idBetween(
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

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      isOutdoorEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOutdoor',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      teacherEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teacher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      teacherGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'teacher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      teacherLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'teacher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      teacherBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'teacher',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      teacherStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'teacher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      teacherEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'teacher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      teacherContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'teacher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      teacherMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'teacher',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      teacherIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teacher',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterFilterCondition>
      teacherIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'teacher',
        value: '',
      ));
    });
  }
}

extension IsarCourseInfoQueryObject
    on QueryBuilder<IsarCourseInfo, IsarCourseInfo, QFilterCondition> {}

extension IsarCourseInfoQueryLinks
    on QueryBuilder<IsarCourseInfo, IsarCourseInfo, QFilterCondition> {}

extension IsarCourseInfoQuerySortBy
    on QueryBuilder<IsarCourseInfo, IsarCourseInfo, QSortBy> {
  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy>
      sortByAbbreviation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'abbreviation', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy>
      sortByAbbreviationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'abbreviation', Sort.desc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> sortByClassroom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'classroom', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy>
      sortByClassroomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'classroom', Sort.desc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> sortByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy>
      sortByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> sortByIsOutdoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOutdoor', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy>
      sortByIsOutdoorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOutdoor', Sort.desc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> sortByTeacher() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teacher', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy>
      sortByTeacherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teacher', Sort.desc);
    });
  }
}

extension IsarCourseInfoQuerySortThenBy
    on QueryBuilder<IsarCourseInfo, IsarCourseInfo, QSortThenBy> {
  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy>
      thenByAbbreviation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'abbreviation', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy>
      thenByAbbreviationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'abbreviation', Sort.desc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> thenByClassroom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'classroom', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy>
      thenByClassroomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'classroom', Sort.desc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> thenByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy>
      thenByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> thenByIsOutdoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOutdoor', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy>
      thenByIsOutdoorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOutdoor', Sort.desc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy> thenByTeacher() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teacher', Sort.asc);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QAfterSortBy>
      thenByTeacherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teacher', Sort.desc);
    });
  }
}

extension IsarCourseInfoQueryWhereDistinct
    on QueryBuilder<IsarCourseInfo, IsarCourseInfo, QDistinct> {
  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QDistinct>
      distinctByAbbreviation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'abbreviation', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QDistinct> distinctByClassroom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'classroom', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QDistinct> distinctByColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QDistinct> distinctByCourseId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QDistinct>
      distinctByIsOutdoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOutdoor');
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCourseInfo, IsarCourseInfo, QDistinct> distinctByTeacher(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teacher', caseSensitive: caseSensitive);
    });
  }
}

extension IsarCourseInfoQueryProperty
    on QueryBuilder<IsarCourseInfo, IsarCourseInfo, QQueryProperty> {
  QueryBuilder<IsarCourseInfo, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarCourseInfo, String, QQueryOperations>
      abbreviationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'abbreviation');
    });
  }

  QueryBuilder<IsarCourseInfo, String, QQueryOperations> classroomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'classroom');
    });
  }

  QueryBuilder<IsarCourseInfo, String, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<IsarCourseInfo, String, QQueryOperations> courseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseId');
    });
  }

  QueryBuilder<IsarCourseInfo, bool, QQueryOperations> isOutdoorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOutdoor');
    });
  }

  QueryBuilder<IsarCourseInfo, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<IsarCourseInfo, String, QQueryOperations> teacherProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teacher');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarTimeLayoutCollection on Isar {
  IsarCollection<IsarTimeLayout> get isarTimeLayouts => this.collection();
}

const IsarTimeLayoutSchema = CollectionSchema(
  name: r'IsarTimeLayout',
  id: 4002730605396580466,
  properties: {
    r'layoutId': PropertySchema(
      id: 0,
      name: r'layoutId',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'timeSlots': PropertySchema(
      id: 2,
      name: r'timeSlots',
      type: IsarType.objectList,
      target: r'IsarTimeSlot',
    )
  },
  estimateSize: _isarTimeLayoutEstimateSize,
  serialize: _isarTimeLayoutSerialize,
  deserialize: _isarTimeLayoutDeserialize,
  deserializeProp: _isarTimeLayoutDeserializeProp,
  idName: r'id',
  indexes: {
    r'layoutId': IndexSchema(
      id: -2455126477743697539,
      name: r'layoutId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'layoutId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'IsarTimeSlot': IsarTimeSlotSchema},
  getId: _isarTimeLayoutGetId,
  getLinks: _isarTimeLayoutGetLinks,
  attach: _isarTimeLayoutAttach,
  version: '3.1.0+1',
);

int _isarTimeLayoutEstimateSize(
  IsarTimeLayout object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.layoutId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.timeSlots.length * 3;
  {
    final offsets = allOffsets[IsarTimeSlot]!;
    for (var i = 0; i < object.timeSlots.length; i++) {
      final value = object.timeSlots[i];
      bytesCount += IsarTimeSlotSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _isarTimeLayoutSerialize(
  IsarTimeLayout object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.layoutId);
  writer.writeString(offsets[1], object.name);
  writer.writeObjectList<IsarTimeSlot>(
    offsets[2],
    allOffsets,
    IsarTimeSlotSchema.serialize,
    object.timeSlots,
  );
}

IsarTimeLayout _isarTimeLayoutDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarTimeLayout();
  object.id = id;
  object.layoutId = reader.readString(offsets[0]);
  object.name = reader.readString(offsets[1]);
  object.timeSlots = reader.readObjectList<IsarTimeSlot>(
        offsets[2],
        IsarTimeSlotSchema.deserialize,
        allOffsets,
        IsarTimeSlot(),
      ) ??
      [];
  return object;
}

P _isarTimeLayoutDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readObjectList<IsarTimeSlot>(
            offset,
            IsarTimeSlotSchema.deserialize,
            allOffsets,
            IsarTimeSlot(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarTimeLayoutGetId(IsarTimeLayout object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarTimeLayoutGetLinks(IsarTimeLayout object) {
  return [];
}

void _isarTimeLayoutAttach(
    IsarCollection<dynamic> col, Id id, IsarTimeLayout object) {
  object.id = id;
}

extension IsarTimeLayoutByIndex on IsarCollection<IsarTimeLayout> {
  Future<IsarTimeLayout?> getByLayoutId(String layoutId) {
    return getByIndex(r'layoutId', [layoutId]);
  }

  IsarTimeLayout? getByLayoutIdSync(String layoutId) {
    return getByIndexSync(r'layoutId', [layoutId]);
  }

  Future<bool> deleteByLayoutId(String layoutId) {
    return deleteByIndex(r'layoutId', [layoutId]);
  }

  bool deleteByLayoutIdSync(String layoutId) {
    return deleteByIndexSync(r'layoutId', [layoutId]);
  }

  Future<List<IsarTimeLayout?>> getAllByLayoutId(List<String> layoutIdValues) {
    final values = layoutIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'layoutId', values);
  }

  List<IsarTimeLayout?> getAllByLayoutIdSync(List<String> layoutIdValues) {
    final values = layoutIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'layoutId', values);
  }

  Future<int> deleteAllByLayoutId(List<String> layoutIdValues) {
    final values = layoutIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'layoutId', values);
  }

  int deleteAllByLayoutIdSync(List<String> layoutIdValues) {
    final values = layoutIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'layoutId', values);
  }

  Future<Id> putByLayoutId(IsarTimeLayout object) {
    return putByIndex(r'layoutId', object);
  }

  Id putByLayoutIdSync(IsarTimeLayout object, {bool saveLinks = true}) {
    return putByIndexSync(r'layoutId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLayoutId(List<IsarTimeLayout> objects) {
    return putAllByIndex(r'layoutId', objects);
  }

  List<Id> putAllByLayoutIdSync(List<IsarTimeLayout> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'layoutId', objects, saveLinks: saveLinks);
  }
}

extension IsarTimeLayoutQueryWhereSort
    on QueryBuilder<IsarTimeLayout, IsarTimeLayout, QWhere> {
  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarTimeLayoutQueryWhere
    on QueryBuilder<IsarTimeLayout, IsarTimeLayout, QWhereClause> {
  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterWhereClause> idBetween(
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

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterWhereClause>
      layoutIdEqualTo(String layoutId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'layoutId',
        value: [layoutId],
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterWhereClause>
      layoutIdNotEqualTo(String layoutId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'layoutId',
              lower: [],
              upper: [layoutId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'layoutId',
              lower: [layoutId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'layoutId',
              lower: [layoutId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'layoutId',
              lower: [],
              upper: [layoutId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarTimeLayoutQueryFilter
    on QueryBuilder<IsarTimeLayout, IsarTimeLayout, QFilterCondition> {
  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
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

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
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

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition> idBetween(
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

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      layoutIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'layoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      layoutIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'layoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      layoutIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'layoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      layoutIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'layoutId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      layoutIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'layoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      layoutIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'layoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      layoutIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'layoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      layoutIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'layoutId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      layoutIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'layoutId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      layoutIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'layoutId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      timeSlotsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timeSlots',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      timeSlotsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timeSlots',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      timeSlotsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timeSlots',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      timeSlotsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timeSlots',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      timeSlotsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timeSlots',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      timeSlotsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timeSlots',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension IsarTimeLayoutQueryObject
    on QueryBuilder<IsarTimeLayout, IsarTimeLayout, QFilterCondition> {
  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterFilterCondition>
      timeSlotsElement(FilterQuery<IsarTimeSlot> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'timeSlots');
    });
  }
}

extension IsarTimeLayoutQueryLinks
    on QueryBuilder<IsarTimeLayout, IsarTimeLayout, QFilterCondition> {}

extension IsarTimeLayoutQuerySortBy
    on QueryBuilder<IsarTimeLayout, IsarTimeLayout, QSortBy> {
  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterSortBy> sortByLayoutId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'layoutId', Sort.asc);
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterSortBy>
      sortByLayoutIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'layoutId', Sort.desc);
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension IsarTimeLayoutQuerySortThenBy
    on QueryBuilder<IsarTimeLayout, IsarTimeLayout, QSortThenBy> {
  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterSortBy> thenByLayoutId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'layoutId', Sort.asc);
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterSortBy>
      thenByLayoutIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'layoutId', Sort.desc);
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension IsarTimeLayoutQueryWhereDistinct
    on QueryBuilder<IsarTimeLayout, IsarTimeLayout, QDistinct> {
  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QDistinct> distinctByLayoutId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'layoutId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTimeLayout, IsarTimeLayout, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension IsarTimeLayoutQueryProperty
    on QueryBuilder<IsarTimeLayout, IsarTimeLayout, QQueryProperty> {
  QueryBuilder<IsarTimeLayout, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarTimeLayout, String, QQueryOperations> layoutIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'layoutId');
    });
  }

  QueryBuilder<IsarTimeLayout, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<IsarTimeLayout, List<IsarTimeSlot>, QQueryOperations>
      timeSlotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeSlots');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarScheduleCollection on Isar {
  IsarCollection<IsarSchedule> get isarSchedules => this.collection();
}

const IsarScheduleSchema = CollectionSchema(
  name: r'IsarSchedule',
  id: 8086699523538935781,
  properties: {
    r'courses': PropertySchema(
      id: 0,
      name: r'courses',
      type: IsarType.objectList,
      target: r'IsarDailyCourse',
    ),
    r'dayTimeLayouts': PropertySchema(
      id: 1,
      name: r'dayTimeLayouts',
      type: IsarType.objectList,
      target: r'IsarDayTimeLayout',
    ),
    r'groupId': PropertySchema(
      id: 2,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'isAutoEnabled': PropertySchema(
      id: 3,
      name: r'isAutoEnabled',
      type: IsarType.bool,
    ),
    r'isOverlay': PropertySchema(
      id: 4,
      name: r'isOverlay',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'overlaySourceId': PropertySchema(
      id: 6,
      name: r'overlaySourceId',
      type: IsarType.string,
    ),
    r'priority': PropertySchema(
      id: 7,
      name: r'priority',
      type: IsarType.long,
    ),
    r'scheduleId': PropertySchema(
      id: 8,
      name: r'scheduleId',
      type: IsarType.string,
    ),
    r'timeLayoutId': PropertySchema(
      id: 9,
      name: r'timeLayoutId',
      type: IsarType.string,
    ),
    r'triggers': PropertySchema(
      id: 10,
      name: r'triggers',
      type: IsarType.objectList,
      target: r'IsarTriggerCondition',
    )
  },
  estimateSize: _isarScheduleEstimateSize,
  serialize: _isarScheduleSerialize,
  deserialize: _isarScheduleDeserialize,
  deserializeProp: _isarScheduleDeserializeProp,
  idName: r'id',
  indexes: {
    r'scheduleId': IndexSchema(
      id: 1899306264659753312,
      name: r'scheduleId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'scheduleId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'IsarTriggerCondition': IsarTriggerConditionSchema,
    r'IsarDayTimeLayout': IsarDayTimeLayoutSchema,
    r'IsarDailyCourse': IsarDailyCourseSchema
  },
  getId: _isarScheduleGetId,
  getLinks: _isarScheduleGetLinks,
  attach: _isarScheduleAttach,
  version: '3.1.0+1',
);

int _isarScheduleEstimateSize(
  IsarSchedule object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.courses.length * 3;
  {
    final offsets = allOffsets[IsarDailyCourse]!;
    for (var i = 0; i < object.courses.length; i++) {
      final value = object.courses[i];
      bytesCount +=
          IsarDailyCourseSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.dayTimeLayouts.length * 3;
  {
    final offsets = allOffsets[IsarDayTimeLayout]!;
    for (var i = 0; i < object.dayTimeLayouts.length; i++) {
      final value = object.dayTimeLayouts[i];
      bytesCount +=
          IsarDayTimeLayoutSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.groupId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.overlaySourceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.scheduleId.length * 3;
  {
    final value = object.timeLayoutId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.triggers.length * 3;
  {
    final offsets = allOffsets[IsarTriggerCondition]!;
    for (var i = 0; i < object.triggers.length; i++) {
      final value = object.triggers[i];
      bytesCount +=
          IsarTriggerConditionSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _isarScheduleSerialize(
  IsarSchedule object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<IsarDailyCourse>(
    offsets[0],
    allOffsets,
    IsarDailyCourseSchema.serialize,
    object.courses,
  );
  writer.writeObjectList<IsarDayTimeLayout>(
    offsets[1],
    allOffsets,
    IsarDayTimeLayoutSchema.serialize,
    object.dayTimeLayouts,
  );
  writer.writeString(offsets[2], object.groupId);
  writer.writeBool(offsets[3], object.isAutoEnabled);
  writer.writeBool(offsets[4], object.isOverlay);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.overlaySourceId);
  writer.writeLong(offsets[7], object.priority);
  writer.writeString(offsets[8], object.scheduleId);
  writer.writeString(offsets[9], object.timeLayoutId);
  writer.writeObjectList<IsarTriggerCondition>(
    offsets[10],
    allOffsets,
    IsarTriggerConditionSchema.serialize,
    object.triggers,
  );
}

IsarSchedule _isarScheduleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarSchedule();
  object.courses = reader.readObjectList<IsarDailyCourse>(
        offsets[0],
        IsarDailyCourseSchema.deserialize,
        allOffsets,
        IsarDailyCourse(),
      ) ??
      [];
  object.dayTimeLayouts = reader.readObjectList<IsarDayTimeLayout>(
        offsets[1],
        IsarDayTimeLayoutSchema.deserialize,
        allOffsets,
        IsarDayTimeLayout(),
      ) ??
      [];
  object.groupId = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.isAutoEnabled = reader.readBool(offsets[3]);
  object.isOverlay = reader.readBool(offsets[4]);
  object.name = reader.readString(offsets[5]);
  object.overlaySourceId = reader.readStringOrNull(offsets[6]);
  object.priority = reader.readLong(offsets[7]);
  object.scheduleId = reader.readString(offsets[8]);
  object.timeLayoutId = reader.readStringOrNull(offsets[9]);
  object.triggers = reader.readObjectList<IsarTriggerCondition>(
        offsets[10],
        IsarTriggerConditionSchema.deserialize,
        allOffsets,
        IsarTriggerCondition(),
      ) ??
      [];
  return object;
}

P _isarScheduleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<IsarDailyCourse>(
            offset,
            IsarDailyCourseSchema.deserialize,
            allOffsets,
            IsarDailyCourse(),
          ) ??
          []) as P;
    case 1:
      return (reader.readObjectList<IsarDayTimeLayout>(
            offset,
            IsarDayTimeLayoutSchema.deserialize,
            allOffsets,
            IsarDayTimeLayout(),
          ) ??
          []) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readObjectList<IsarTriggerCondition>(
            offset,
            IsarTriggerConditionSchema.deserialize,
            allOffsets,
            IsarTriggerCondition(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarScheduleGetId(IsarSchedule object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarScheduleGetLinks(IsarSchedule object) {
  return [];
}

void _isarScheduleAttach(
    IsarCollection<dynamic> col, Id id, IsarSchedule object) {
  object.id = id;
}

extension IsarScheduleByIndex on IsarCollection<IsarSchedule> {
  Future<IsarSchedule?> getByScheduleId(String scheduleId) {
    return getByIndex(r'scheduleId', [scheduleId]);
  }

  IsarSchedule? getByScheduleIdSync(String scheduleId) {
    return getByIndexSync(r'scheduleId', [scheduleId]);
  }

  Future<bool> deleteByScheduleId(String scheduleId) {
    return deleteByIndex(r'scheduleId', [scheduleId]);
  }

  bool deleteByScheduleIdSync(String scheduleId) {
    return deleteByIndexSync(r'scheduleId', [scheduleId]);
  }

  Future<List<IsarSchedule?>> getAllByScheduleId(
      List<String> scheduleIdValues) {
    final values = scheduleIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'scheduleId', values);
  }

  List<IsarSchedule?> getAllByScheduleIdSync(List<String> scheduleIdValues) {
    final values = scheduleIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'scheduleId', values);
  }

  Future<int> deleteAllByScheduleId(List<String> scheduleIdValues) {
    final values = scheduleIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'scheduleId', values);
  }

  int deleteAllByScheduleIdSync(List<String> scheduleIdValues) {
    final values = scheduleIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'scheduleId', values);
  }

  Future<Id> putByScheduleId(IsarSchedule object) {
    return putByIndex(r'scheduleId', object);
  }

  Id putByScheduleIdSync(IsarSchedule object, {bool saveLinks = true}) {
    return putByIndexSync(r'scheduleId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByScheduleId(List<IsarSchedule> objects) {
    return putAllByIndex(r'scheduleId', objects);
  }

  List<Id> putAllByScheduleIdSync(List<IsarSchedule> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'scheduleId', objects, saveLinks: saveLinks);
  }
}

extension IsarScheduleQueryWhereSort
    on QueryBuilder<IsarSchedule, IsarSchedule, QWhere> {
  QueryBuilder<IsarSchedule, IsarSchedule, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarScheduleQueryWhere
    on QueryBuilder<IsarSchedule, IsarSchedule, QWhereClause> {
  QueryBuilder<IsarSchedule, IsarSchedule, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterWhereClause> idBetween(
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

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterWhereClause> scheduleIdEqualTo(
      String scheduleId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'scheduleId',
        value: [scheduleId],
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterWhereClause>
      scheduleIdNotEqualTo(String scheduleId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduleId',
              lower: [],
              upper: [scheduleId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduleId',
              lower: [scheduleId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduleId',
              lower: [scheduleId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduleId',
              lower: [],
              upper: [scheduleId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarScheduleQueryFilter
    on QueryBuilder<IsarSchedule, IsarSchedule, QFilterCondition> {
  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      coursesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'courses',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      coursesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'courses',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      coursesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'courses',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      coursesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'courses',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      coursesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'courses',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      coursesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'courses',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      dayTimeLayoutsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dayTimeLayouts',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      dayTimeLayoutsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dayTimeLayouts',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      dayTimeLayoutsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dayTimeLayouts',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      dayTimeLayoutsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dayTimeLayouts',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      dayTimeLayoutsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dayTimeLayouts',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      dayTimeLayoutsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dayTimeLayouts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      groupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      groupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      groupIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      groupIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      groupIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      groupIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      groupIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      groupIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      groupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      groupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition> idBetween(
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

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      isAutoEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAutoEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      isOverlayEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOverlay',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      overlaySourceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'overlaySourceId',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      overlaySourceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'overlaySourceId',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      overlaySourceIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overlaySourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      overlaySourceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'overlaySourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      overlaySourceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'overlaySourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      overlaySourceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'overlaySourceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      overlaySourceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'overlaySourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      overlaySourceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'overlaySourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      overlaySourceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'overlaySourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      overlaySourceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'overlaySourceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      overlaySourceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overlaySourceId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      overlaySourceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'overlaySourceId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      priorityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      priorityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      priorityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      priorityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      scheduleIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      scheduleIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      scheduleIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      scheduleIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      scheduleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      scheduleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      scheduleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scheduleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      scheduleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scheduleId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      scheduleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduleId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      scheduleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scheduleId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      timeLayoutIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timeLayoutId',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      timeLayoutIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timeLayoutId',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      timeLayoutIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeLayoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      timeLayoutIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeLayoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      timeLayoutIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeLayoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      timeLayoutIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeLayoutId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      timeLayoutIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timeLayoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      timeLayoutIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timeLayoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      timeLayoutIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timeLayoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      timeLayoutIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timeLayoutId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      timeLayoutIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeLayoutId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      timeLayoutIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'timeLayoutId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      triggersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'triggers',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      triggersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'triggers',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      triggersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'triggers',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      triggersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'triggers',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      triggersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'triggers',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      triggersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'triggers',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension IsarScheduleQueryObject
    on QueryBuilder<IsarSchedule, IsarSchedule, QFilterCondition> {
  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      coursesElement(FilterQuery<IsarDailyCourse> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'courses');
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      dayTimeLayoutsElement(FilterQuery<IsarDayTimeLayout> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'dayTimeLayouts');
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterFilterCondition>
      triggersElement(FilterQuery<IsarTriggerCondition> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'triggers');
    });
  }
}

extension IsarScheduleQueryLinks
    on QueryBuilder<IsarSchedule, IsarSchedule, QFilterCondition> {}

extension IsarScheduleQuerySortBy
    on QueryBuilder<IsarSchedule, IsarSchedule, QSortBy> {
  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> sortByIsAutoEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAutoEnabled', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy>
      sortByIsAutoEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAutoEnabled', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> sortByIsOverlay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverlay', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> sortByIsOverlayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverlay', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy>
      sortByOverlaySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overlaySourceId', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy>
      sortByOverlaySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overlaySourceId', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> sortByScheduleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy>
      sortByScheduleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> sortByTimeLayoutId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeLayoutId', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy>
      sortByTimeLayoutIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeLayoutId', Sort.desc);
    });
  }
}

extension IsarScheduleQuerySortThenBy
    on QueryBuilder<IsarSchedule, IsarSchedule, QSortThenBy> {
  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> thenByIsAutoEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAutoEnabled', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy>
      thenByIsAutoEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAutoEnabled', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> thenByIsOverlay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverlay', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> thenByIsOverlayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverlay', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy>
      thenByOverlaySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overlaySourceId', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy>
      thenByOverlaySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overlaySourceId', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> thenByScheduleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy>
      thenByScheduleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.desc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy> thenByTimeLayoutId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeLayoutId', Sort.asc);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QAfterSortBy>
      thenByTimeLayoutIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeLayoutId', Sort.desc);
    });
  }
}

extension IsarScheduleQueryWhereDistinct
    on QueryBuilder<IsarSchedule, IsarSchedule, QDistinct> {
  QueryBuilder<IsarSchedule, IsarSchedule, QDistinct> distinctByGroupId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QDistinct>
      distinctByIsAutoEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAutoEnabled');
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QDistinct> distinctByIsOverlay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOverlay');
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QDistinct> distinctByOverlaySourceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overlaySourceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QDistinct> distinctByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority');
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QDistinct> distinctByScheduleId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduleId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSchedule, IsarSchedule, QDistinct> distinctByTimeLayoutId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeLayoutId', caseSensitive: caseSensitive);
    });
  }
}

extension IsarScheduleQueryProperty
    on QueryBuilder<IsarSchedule, IsarSchedule, QQueryProperty> {
  QueryBuilder<IsarSchedule, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarSchedule, List<IsarDailyCourse>, QQueryOperations>
      coursesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courses');
    });
  }

  QueryBuilder<IsarSchedule, List<IsarDayTimeLayout>, QQueryOperations>
      dayTimeLayoutsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayTimeLayouts');
    });
  }

  QueryBuilder<IsarSchedule, String?, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<IsarSchedule, bool, QQueryOperations> isAutoEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAutoEnabled');
    });
  }

  QueryBuilder<IsarSchedule, bool, QQueryOperations> isOverlayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOverlay');
    });
  }

  QueryBuilder<IsarSchedule, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<IsarSchedule, String?, QQueryOperations>
      overlaySourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overlaySourceId');
    });
  }

  QueryBuilder<IsarSchedule, int, QQueryOperations> priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<IsarSchedule, String, QQueryOperations> scheduleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduleId');
    });
  }

  QueryBuilder<IsarSchedule, String?, QQueryOperations> timeLayoutIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeLayoutId');
    });
  }

  QueryBuilder<IsarSchedule, List<IsarTriggerCondition>, QQueryOperations>
      triggersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggers');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarScheduleGroupCollection on Isar {
  IsarCollection<IsarScheduleGroup> get isarScheduleGroups => this.collection();
}

const IsarScheduleGroupSchema = CollectionSchema(
  name: r'IsarScheduleGroup',
  id: 4987363535183311440,
  properties: {
    r'groupId': PropertySchema(
      id: 0,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'parentId': PropertySchema(
      id: 2,
      name: r'parentId',
      type: IsarType.string,
    )
  },
  estimateSize: _isarScheduleGroupEstimateSize,
  serialize: _isarScheduleGroupSerialize,
  deserialize: _isarScheduleGroupDeserialize,
  deserializeProp: _isarScheduleGroupDeserializeProp,
  idName: r'id',
  indexes: {
    r'groupId': IndexSchema(
      id: -8523216633229774932,
      name: r'groupId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'groupId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarScheduleGroupGetId,
  getLinks: _isarScheduleGroupGetLinks,
  attach: _isarScheduleGroupAttach,
  version: '3.1.0+1',
);

int _isarScheduleGroupEstimateSize(
  IsarScheduleGroup object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.groupId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.parentId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _isarScheduleGroupSerialize(
  IsarScheduleGroup object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.groupId);
  writer.writeString(offsets[1], object.name);
  writer.writeString(offsets[2], object.parentId);
}

IsarScheduleGroup _isarScheduleGroupDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarScheduleGroup();
  object.groupId = reader.readString(offsets[0]);
  object.id = id;
  object.name = reader.readString(offsets[1]);
  object.parentId = reader.readStringOrNull(offsets[2]);
  return object;
}

P _isarScheduleGroupDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarScheduleGroupGetId(IsarScheduleGroup object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarScheduleGroupGetLinks(
    IsarScheduleGroup object) {
  return [];
}

void _isarScheduleGroupAttach(
    IsarCollection<dynamic> col, Id id, IsarScheduleGroup object) {
  object.id = id;
}

extension IsarScheduleGroupByIndex on IsarCollection<IsarScheduleGroup> {
  Future<IsarScheduleGroup?> getByGroupId(String groupId) {
    return getByIndex(r'groupId', [groupId]);
  }

  IsarScheduleGroup? getByGroupIdSync(String groupId) {
    return getByIndexSync(r'groupId', [groupId]);
  }

  Future<bool> deleteByGroupId(String groupId) {
    return deleteByIndex(r'groupId', [groupId]);
  }

  bool deleteByGroupIdSync(String groupId) {
    return deleteByIndexSync(r'groupId', [groupId]);
  }

  Future<List<IsarScheduleGroup?>> getAllByGroupId(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'groupId', values);
  }

  List<IsarScheduleGroup?> getAllByGroupIdSync(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'groupId', values);
  }

  Future<int> deleteAllByGroupId(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'groupId', values);
  }

  int deleteAllByGroupIdSync(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'groupId', values);
  }

  Future<Id> putByGroupId(IsarScheduleGroup object) {
    return putByIndex(r'groupId', object);
  }

  Id putByGroupIdSync(IsarScheduleGroup object, {bool saveLinks = true}) {
    return putByIndexSync(r'groupId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByGroupId(List<IsarScheduleGroup> objects) {
    return putAllByIndex(r'groupId', objects);
  }

  List<Id> putAllByGroupIdSync(List<IsarScheduleGroup> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'groupId', objects, saveLinks: saveLinks);
  }
}

extension IsarScheduleGroupQueryWhereSort
    on QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QWhere> {
  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarScheduleGroupQueryWhere
    on QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QWhereClause> {
  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterWhereClause>
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

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterWhereClause>
      groupIdEqualTo(String groupId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupId',
        value: [groupId],
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterWhereClause>
      groupIdNotEqualTo(String groupId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarScheduleGroupQueryFilter
    on QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QFilterCondition> {
  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      groupIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      groupIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      groupIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      groupIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      groupIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      groupIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      groupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      groupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
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

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
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

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
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

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      parentIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentId',
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      parentIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentId',
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      parentIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      parentIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      parentIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      parentIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      parentIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      parentIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      parentIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      parentIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parentId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      parentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterFilterCondition>
      parentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentId',
        value: '',
      ));
    });
  }
}

extension IsarScheduleGroupQueryObject
    on QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QFilterCondition> {}

extension IsarScheduleGroupQueryLinks
    on QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QFilterCondition> {}

extension IsarScheduleGroupQuerySortBy
    on QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QSortBy> {
  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy>
      sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy>
      sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy>
      sortByParentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.asc);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy>
      sortByParentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.desc);
    });
  }
}

extension IsarScheduleGroupQuerySortThenBy
    on QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QSortThenBy> {
  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy>
      thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy>
      thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy>
      thenByParentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.asc);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QAfterSortBy>
      thenByParentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.desc);
    });
  }
}

extension IsarScheduleGroupQueryWhereDistinct
    on QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QDistinct> {
  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QDistinct>
      distinctByGroupId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QDistinct>
      distinctByParentId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentId', caseSensitive: caseSensitive);
    });
  }
}

extension IsarScheduleGroupQueryProperty
    on QueryBuilder<IsarScheduleGroup, IsarScheduleGroup, QQueryProperty> {
  QueryBuilder<IsarScheduleGroup, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarScheduleGroup, String, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<IsarScheduleGroup, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<IsarScheduleGroup, String?, QQueryOperations>
      parentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentId');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarTimeSlotSchema = Schema(
  name: r'IsarTimeSlot',
  id: -2173674784738429917,
  properties: {
    r'defaultSubjectId': PropertySchema(
      id: 0,
      name: r'defaultSubjectId',
      type: IsarType.string,
    ),
    r'endTime': PropertySchema(
      id: 1,
      name: r'endTime',
      type: IsarType.string,
    ),
    r'isHiddenByDefault': PropertySchema(
      id: 2,
      name: r'isHiddenByDefault',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'slotId': PropertySchema(
      id: 4,
      name: r'slotId',
      type: IsarType.string,
    ),
    r'startTime': PropertySchema(
      id: 5,
      name: r'startTime',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 6,
      name: r'type',
      type: IsarType.long,
    )
  },
  estimateSize: _isarTimeSlotEstimateSize,
  serialize: _isarTimeSlotSerialize,
  deserialize: _isarTimeSlotDeserialize,
  deserializeProp: _isarTimeSlotDeserializeProp,
);

int _isarTimeSlotEstimateSize(
  IsarTimeSlot object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.defaultSubjectId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.endTime.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.slotId.length * 3;
  bytesCount += 3 + object.startTime.length * 3;
  return bytesCount;
}

void _isarTimeSlotSerialize(
  IsarTimeSlot object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.defaultSubjectId);
  writer.writeString(offsets[1], object.endTime);
  writer.writeBool(offsets[2], object.isHiddenByDefault);
  writer.writeString(offsets[3], object.name);
  writer.writeString(offsets[4], object.slotId);
  writer.writeString(offsets[5], object.startTime);
  writer.writeLong(offsets[6], object.type);
}

IsarTimeSlot _isarTimeSlotDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarTimeSlot();
  object.defaultSubjectId = reader.readStringOrNull(offsets[0]);
  object.endTime = reader.readString(offsets[1]);
  object.isHiddenByDefault = reader.readBool(offsets[2]);
  object.name = reader.readString(offsets[3]);
  object.slotId = reader.readString(offsets[4]);
  object.startTime = reader.readString(offsets[5]);
  object.type = reader.readLong(offsets[6]);
  return object;
}

P _isarTimeSlotDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarTimeSlotQueryFilter
    on QueryBuilder<IsarTimeSlot, IsarTimeSlot, QFilterCondition> {
  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      defaultSubjectIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'defaultSubjectId',
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      defaultSubjectIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'defaultSubjectId',
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      defaultSubjectIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultSubjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      defaultSubjectIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultSubjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      defaultSubjectIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultSubjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      defaultSubjectIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultSubjectId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      defaultSubjectIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'defaultSubjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      defaultSubjectIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'defaultSubjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      defaultSubjectIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'defaultSubjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      defaultSubjectIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'defaultSubjectId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      defaultSubjectIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultSubjectId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      defaultSubjectIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'defaultSubjectId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      endTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      endTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      endTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      endTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      endTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      endTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      endTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      endTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'endTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      endTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      endTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'endTime',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      isHiddenByDefaultEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isHiddenByDefault',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition> slotIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      slotIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      slotIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition> slotIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slotId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      slotIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      slotIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      slotIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition> slotIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slotId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      slotIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slotId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      slotIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slotId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      startTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      startTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      startTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      startTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      startTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      startTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      startTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      startTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'startTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      startTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      startTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'startTime',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition> typeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition>
      typeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition> typeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTimeSlot, IsarTimeSlot, QAfterFilterCondition> typeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarTimeSlotQueryObject
    on QueryBuilder<IsarTimeSlot, IsarTimeSlot, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarTriggerConditionSchema = Schema(
  name: r'IsarTriggerCondition',
  id: -8032945382885732312,
  properties: {
    r'conditionId': PropertySchema(
      id: 0,
      name: r'conditionId',
      type: IsarType.string,
    ),
    r'dates': PropertySchema(
      id: 1,
      name: r'dates',
      type: IsarType.dateTimeList,
    ),
    r'endWeek': PropertySchema(
      id: 2,
      name: r'endWeek',
      type: IsarType.long,
    ),
    r'startWeek': PropertySchema(
      id: 3,
      name: r'startWeek',
      type: IsarType.long,
    ),
    r'weekDays': PropertySchema(
      id: 4,
      name: r'weekDays',
      type: IsarType.longList,
    ),
    r'weekNumbers': PropertySchema(
      id: 5,
      name: r'weekNumbers',
      type: IsarType.longList,
    )
  },
  estimateSize: _isarTriggerConditionEstimateSize,
  serialize: _isarTriggerConditionSerialize,
  deserialize: _isarTriggerConditionDeserialize,
  deserializeProp: _isarTriggerConditionDeserializeProp,
);

int _isarTriggerConditionEstimateSize(
  IsarTriggerCondition object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.conditionId.length * 3;
  {
    final value = object.dates;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.weekDays;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.weekNumbers;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  return bytesCount;
}

void _isarTriggerConditionSerialize(
  IsarTriggerCondition object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.conditionId);
  writer.writeDateTimeList(offsets[1], object.dates);
  writer.writeLong(offsets[2], object.endWeek);
  writer.writeLong(offsets[3], object.startWeek);
  writer.writeLongList(offsets[4], object.weekDays);
  writer.writeLongList(offsets[5], object.weekNumbers);
}

IsarTriggerCondition _isarTriggerConditionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarTriggerCondition();
  object.conditionId = reader.readString(offsets[0]);
  object.dates = reader.readDateTimeList(offsets[1]);
  object.endWeek = reader.readLongOrNull(offsets[2]);
  object.startWeek = reader.readLongOrNull(offsets[3]);
  object.weekDays = reader.readLongList(offsets[4]);
  object.weekNumbers = reader.readLongList(offsets[5]);
  return object;
}

P _isarTriggerConditionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTimeList(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongList(offset)) as P;
    case 5:
      return (reader.readLongList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarTriggerConditionQueryFilter on QueryBuilder<IsarTriggerCondition,
    IsarTriggerCondition, QFilterCondition> {
  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> conditionIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'conditionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> conditionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'conditionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> conditionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'conditionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> conditionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'conditionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> conditionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'conditionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> conditionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'conditionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
          QAfterFilterCondition>
      conditionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'conditionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
          QAfterFilterCondition>
      conditionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'conditionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> conditionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'conditionId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> conditionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'conditionId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> datesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dates',
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> datesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dates',
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> datesElementEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dates',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> datesElementGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dates',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> datesElementLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dates',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> datesElementBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> datesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dates',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> datesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dates',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> datesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dates',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> datesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dates',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> datesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dates',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> datesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dates',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> endWeekIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endWeek',
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> endWeekIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endWeek',
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> endWeekEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> endWeekGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> endWeekLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> endWeekBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> startWeekIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startWeek',
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> startWeekIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startWeek',
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> startWeekEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> startWeekGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> startWeekLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> startWeekBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekDaysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weekDays',
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekDaysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weekDays',
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekDaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekDays',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekDaysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekDays',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekDaysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekDays',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekDaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekNumbersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weekNumbers',
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekNumbersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weekNumbers',
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekNumbersElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekNumbers',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekNumbersElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekNumbers',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekNumbersElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekNumbers',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekNumbersElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekNumbers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekNumbersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekNumbers',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekNumbersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekNumbers',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekNumbersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekNumbers',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekNumbersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekNumbers',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekNumbersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekNumbers',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarTriggerCondition, IsarTriggerCondition,
      QAfterFilterCondition> weekNumbersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekNumbers',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension IsarTriggerConditionQueryObject on QueryBuilder<IsarTriggerCondition,
    IsarTriggerCondition, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarDayTimeLayoutSchema = Schema(
  name: r'IsarDayTimeLayout',
  id: 6044568601324824142,
  properties: {
    r'dayOfWeek': PropertySchema(
      id: 0,
      name: r'dayOfWeek',
      type: IsarType.long,
    ),
    r'layoutId': PropertySchema(
      id: 1,
      name: r'layoutId',
      type: IsarType.string,
    )
  },
  estimateSize: _isarDayTimeLayoutEstimateSize,
  serialize: _isarDayTimeLayoutSerialize,
  deserialize: _isarDayTimeLayoutDeserialize,
  deserializeProp: _isarDayTimeLayoutDeserializeProp,
);

int _isarDayTimeLayoutEstimateSize(
  IsarDayTimeLayout object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.layoutId.length * 3;
  return bytesCount;
}

void _isarDayTimeLayoutSerialize(
  IsarDayTimeLayout object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dayOfWeek);
  writer.writeString(offsets[1], object.layoutId);
}

IsarDayTimeLayout _isarDayTimeLayoutDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarDayTimeLayout();
  object.dayOfWeek = reader.readLong(offsets[0]);
  object.layoutId = reader.readString(offsets[1]);
  return object;
}

P _isarDayTimeLayoutDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarDayTimeLayoutQueryFilter
    on QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QFilterCondition> {
  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      dayOfWeekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      dayOfWeekGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      dayOfWeekLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      dayOfWeekBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayOfWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      layoutIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'layoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      layoutIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'layoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      layoutIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'layoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      layoutIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'layoutId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      layoutIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'layoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      layoutIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'layoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      layoutIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'layoutId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      layoutIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'layoutId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      layoutIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'layoutId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QAfterFilterCondition>
      layoutIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'layoutId',
        value: '',
      ));
    });
  }
}

extension IsarDayTimeLayoutQueryObject
    on QueryBuilder<IsarDayTimeLayout, IsarDayTimeLayout, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarDailyCourseSchema = Schema(
  name: r'IsarDailyCourse',
  id: -9154626052636516503,
  properties: {
    r'courseId': PropertySchema(
      id: 0,
      name: r'courseId',
      type: IsarType.string,
    ),
    r'dailyCourseId': PropertySchema(
      id: 1,
      name: r'dailyCourseId',
      type: IsarType.string,
    ),
    r'dayOfWeek': PropertySchema(
      id: 2,
      name: r'dayOfWeek',
      type: IsarType.long,
    ),
    r'isChangedClass': PropertySchema(
      id: 3,
      name: r'isChangedClass',
      type: IsarType.bool,
    ),
    r'timeSlotId': PropertySchema(
      id: 4,
      name: r'timeSlotId',
      type: IsarType.string,
    ),
    r'weekType': PropertySchema(
      id: 5,
      name: r'weekType',
      type: IsarType.long,
    )
  },
  estimateSize: _isarDailyCourseEstimateSize,
  serialize: _isarDailyCourseSerialize,
  deserialize: _isarDailyCourseDeserialize,
  deserializeProp: _isarDailyCourseDeserializeProp,
);

int _isarDailyCourseEstimateSize(
  IsarDailyCourse object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.courseId.length * 3;
  bytesCount += 3 + object.dailyCourseId.length * 3;
  bytesCount += 3 + object.timeSlotId.length * 3;
  return bytesCount;
}

void _isarDailyCourseSerialize(
  IsarDailyCourse object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.courseId);
  writer.writeString(offsets[1], object.dailyCourseId);
  writer.writeLong(offsets[2], object.dayOfWeek);
  writer.writeBool(offsets[3], object.isChangedClass);
  writer.writeString(offsets[4], object.timeSlotId);
  writer.writeLong(offsets[5], object.weekType);
}

IsarDailyCourse _isarDailyCourseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarDailyCourse();
  object.courseId = reader.readString(offsets[0]);
  object.dailyCourseId = reader.readString(offsets[1]);
  object.dayOfWeek = reader.readLong(offsets[2]);
  object.isChangedClass = reader.readBool(offsets[3]);
  object.timeSlotId = reader.readString(offsets[4]);
  object.weekType = reader.readLong(offsets[5]);
  return object;
}

P _isarDailyCourseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarDailyCourseQueryFilter
    on QueryBuilder<IsarDailyCourse, IsarDailyCourse, QFilterCondition> {
  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      courseIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      courseIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      courseIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      courseIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'courseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      courseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      courseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      courseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      courseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'courseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      courseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      courseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'courseId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dailyCourseIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyCourseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dailyCourseIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyCourseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dailyCourseIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyCourseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dailyCourseIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyCourseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dailyCourseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dailyCourseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dailyCourseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dailyCourseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dailyCourseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dailyCourseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dailyCourseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dailyCourseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dailyCourseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyCourseId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dailyCourseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dailyCourseId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dayOfWeekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dayOfWeekGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dayOfWeekLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      dayOfWeekBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayOfWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      isChangedClassEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isChangedClass',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      timeSlotIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeSlotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      timeSlotIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeSlotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      timeSlotIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeSlotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      timeSlotIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeSlotId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      timeSlotIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timeSlotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      timeSlotIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timeSlotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      timeSlotIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timeSlotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      timeSlotIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timeSlotId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      timeSlotIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeSlotId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      timeSlotIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'timeSlotId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      weekTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekType',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      weekTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekType',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      weekTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekType',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDailyCourse, IsarDailyCourse, QAfterFilterCondition>
      weekTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarDailyCourseQueryObject
    on QueryBuilder<IsarDailyCourse, IsarDailyCourse, QFilterCondition> {}
