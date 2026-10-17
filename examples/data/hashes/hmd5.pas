// See some samples in: http://en.wikipedia.org/wiki/Hash-based_message_authentication_code
program hmd5;

{$mode objfpc}{$H+}

uses
  SysUtils, HlpHashFactory;

begin
  // for HMAC_MD5("", "") = 0x74e6f7298a9c2d168935f58c001bad88
  WriteLn('Example 1: ', LowerCase(THashFactory.THMAC.CreateHMAC(THashFactory.TCrypto.CreateMD5).ComputeString('', TEncoding.UTF8).ToString(False)));
  // for HMAC_MD5("key", "The quick brown fox jumps over the lazy dog") = 0x80070713463e7749b90c2dc24911e275
  WriteLn('Example 2: ', LowerCase(THashFactory.THMAC.CreateHMAC(THashFactory.TCrypto.CreateMD5, TEncoding.UTF8.GetBytes('key')).ComputeString('The quick brown fox jumps over the lazy dog', TEncoding.UTF8).ToString(False)));
end.

