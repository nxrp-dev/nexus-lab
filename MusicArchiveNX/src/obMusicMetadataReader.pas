unit obMusicMetadataReader;

{$mode objfpc}{$H+}

interface

type
  TMusicMediaInfo = record
    FormatName: string;
    DurationMs: Int64;
    SampleRateHz: Integer;
    ChannelCount: Integer;
  end;

  TMusicMetadataReader = class
  public
    function DescribeFile(const AFileName: string): TMusicMediaInfo; virtual;
  end;

implementation

function TMusicMetadataReader.DescribeFile(const AFileName: string): TMusicMediaInfo;
begin
  Result.FormatName := '';
  Result.DurationMs := 0;
  Result.SampleRateHz := 0;
  Result.ChannelCount := 0;
end;

end.
