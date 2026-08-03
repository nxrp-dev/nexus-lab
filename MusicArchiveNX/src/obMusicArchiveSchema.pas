unit obMusicArchiveSchema;

{$mode objfpc}{$H+}

interface

const
  cMusicArchiveSchemaVersion = 1;

  cSQLCreateArchiveMeta =
    'create table if not exists archive_meta (' +
    'key text primary key, ' +
    'value text not null)';

  cSQLCreateRecording =
    'create table if not exists recording (' +
    'id integer primary key, ' +
    'stable_id text not null unique, ' +
    'title text not null, ' +
    'description text not null default '''', ' +
    'imported_at_utc text not null, ' +
    'original_filename text not null, ' +
    'original_source_path text not null, ' +
    'content_hash text not null, ' +
    'content_hash_algorithm text not null, ' +
    'file_size_bytes integer not null, ' +
    'media_format text not null, ' +
    'duration_ms integer, ' +
    'sample_rate_hz integer, ' +
    'channel_count integer, ' +
    'recorded_at_utc text, ' +
    'created_at_utc text not null, ' +
    'updated_at_utc text not null)';

  cSQLCreateRecordingHashIndex =
    'create unique index if not exists idx_recording_content_hash ' +
    'on recording(content_hash_algorithm, content_hash)';

  cSQLCreateRecordingContent =
    'create table if not exists recording_content (' +
    'recording_id integer primary key, ' +
    'content blob not null, ' +
    'content_size_bytes integer not null, ' +
    'content_hash text not null, ' +
    'content_hash_algorithm text not null, ' +
    'stored_at_utc text not null, ' +
    'foreign key(recording_id) references recording(id) on delete cascade, ' +
    'check(content_size_bytes >= 0))';

  cSQLCreateRecordingContentChunk =
    'create table if not exists recording_content_chunk (' +
    'recording_id integer not null, ' +
    'chunk_index integer not null, ' +
    'chunk_offset integer not null, ' +
    'content blob not null, ' +
    'content_size_bytes integer not null, ' +
    'primary key(recording_id, chunk_index), ' +
    'foreign key(recording_id) references recording(id) on delete cascade, ' +
    'check(chunk_index >= 0), ' +
    'check(chunk_offset >= 0), ' +
    'check(content_size_bytes > 0))';

  cSQLCreateRecordingSource =
    'create table if not exists recording_source (' +
    'id integer primary key, ' +
    'recording_id integer not null, ' +
    'source_path text not null, ' +
    'source_filename text not null, ' +
    'source_root text not null, ' +
    'source_modified_at_utc text, ' +
    'source_size_bytes integer, ' +
    'imported_at_utc text not null, ' +
    'import_batch_id text not null, ' +
    'foreign key(recording_id) references recording(id) on delete cascade)';

  cSQLCreateCategory =
    'create table if not exists category (' +
    'id integer primary key, ' +
    'parent_id integer, ' +
    'name text not null, ' +
    'sort_order integer not null default 0, ' +
    'foreign key(parent_id) references category(id) on delete set null)';

  cSQLCreateRecordingCategory =
    'create table if not exists recording_category (' +
    'recording_id integer not null, ' +
    'category_id integer not null, ' +
    'primary key(recording_id, category_id), ' +
    'foreign key(recording_id) references recording(id) on delete cascade, ' +
    'foreign key(category_id) references category(id) on delete cascade)';

  cSQLCreateTag =
    'create table if not exists tag (' +
    'id integer primary key, ' +
    'name text not null unique)';

  cSQLCreateRecordingTag =
    'create table if not exists recording_tag (' +
    'recording_id integer not null, ' +
    'tag_id integer not null, ' +
    'primary key(recording_id, tag_id), ' +
    'foreign key(recording_id) references recording(id) on delete cascade, ' +
    'foreign key(tag_id) references tag(id) on delete cascade)';

  cSQLCreateAnnotation =
    'create table if not exists annotation (' +
    'id integer primary key, ' +
    'recording_id integer not null, ' +
    'start_ms integer not null, ' +
    'end_ms integer not null, ' +
    'title text not null, ' +
    'body text not null default '''', ' +
    'annotation_type text not null default '''', ' +
    'created_at_utc text not null, ' +
    'updated_at_utc text not null, ' +
    'foreign key(recording_id) references recording(id) on delete cascade, ' +
    'check(start_ms >= 0), ' +
    'check(end_ms > start_ms))';

  cSQLCreateAnnotationRangeIndex =
    'create index if not exists idx_annotation_recording_range ' +
    'on annotation(recording_id, start_ms, end_ms)';

implementation

end.
