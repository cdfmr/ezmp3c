//------------------------------------------------------------------------------
// Project: Ogg Vorbis Pascal Translation
// Unit:    ogglite.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Minimal translation for ogg vorbis encoding only
//
// 2006-04-16
// - Initial release with comments
//------------------------------------------------------------------------------

unit ogglite;

interface

uses Windows;

const
  OGGLIB       = 'libogg-0.dll';
  VORBISLIB    = 'libvorbis-0.dll';
  VORBISENCLIB = 'libvorbisenc-2.dll';
//  OGGLIB       = 'ogg.dll';
//  VORBISLIB    = 'vorbis.dll';
//  VORBISENCLIB = 'vorbisenc.dll';

type

  // type define
  int = Integer;
  long = Integer;
  float = single;
  pfloat = ^float;
  ppfloat = ^pfloat;
  ogg_int64_t = int64;

  //////////////////////////////////////////////////////////////////////////////
  // records
  
  oggpack_buffer = record
    endbyte: long;
    endbit: int;
    buffer: PChar;
    ptr: PChar;
    storage: long;
  end;

  ogg_page = record
    header: PChar;
    header_len: long;
    body: PChar;
    body_len: long;
  end;

  ogg_stream_state = record
    body_data: PChar;
    body_storage: long;
    body_fill: long;
    body_returned: long;
    lacing_vals: ^int;
    granule_vals: ^ogg_int64_t;
    lacing_storage: long;
    lacing_fill: long;
    lacing_packet: long;
    lacing_returned: long;
    header: array[0..282 - 1] of Char;
    header_fill: int;
    e_o_s: int;
    b_o_s: int;
    serialno: long;
    pageno: long;
    packetno: ogg_int64_t;
    granulepos: ogg_int64_t;
  end;

  ogg_packet = record
    packet: PChar;
    bytes: long;
    b_o_s: long;
    e_o_s: long;
    granulepos: ogg_int64_t;
    packetno: ogg_int64_t;
  end;

  p_alloc_chain = ^alloc_chain;
  alloc_chain = record
    ptr: Pointer;
    next: p_alloc_chain;
  end;

  p_vorbis_info = ^vorbis_info;
  vorbis_info = record
    version: int;
    channels: int;
    rate: long;
    bitrate_upper: long;
    bitrate_nominal: long;
    bitrate_lower: long;
    bitrate_window: long;
    codec_setup: Pointer;
  end;

  p_vorbis_dsp_state = ^vorbis_dsp_state;
  vorbis_dsp_state = record
    analysisp: int;
    vi: p_vorbis_info;
    pcm: ppfloat;
    pcmret: ppfloat;
    pcm_storage: int;
    pcm_current: int;
    pcm_returned: int;
    preextrapolate: int;
    eofflag: int;
    lW: long;
    W: long;
    nW: long;
    centerW: long;
    granulepos: ogg_int64_t;
    sequence: ogg_int64_t;
    glue_bits: ogg_int64_t;
    time_bits: ogg_int64_t;
    floor_bits: ogg_int64_t;
    res_bits: ogg_int64_t;
    backend_state: Pointer;
  end;

  vorbis_block = record
    pcm: ppfloat;
    opb: oggpack_buffer;
    lW: long;
    W: long;
    nW: long;
    pcmend: int;
    mode: int;
    eofflag: int;
    granulepos: ogg_int64_t;
    sequence: ogg_int64_t;
    vd: p_vorbis_dsp_state;
    localstore: Pointer;
    localtop: long;
    localalloc: long;
    totaluse: long;
    reap: p_alloc_chain;
    glue_bits: long;
    time_bits: long;
    floor_bits: long;
    res_bits: long;
    internal: Pointer;
  end;

  vorbis_comment = record
    user_comments: ^PChar;
    comment_lengths: ^int;
    comments: int;
    vendor: PChar;
  end;

// functions of ogg.dll
function ogg_stream_init(var os: ogg_stream_state; serialno: int): int; cdecl; external OGGLIB;
function ogg_stream_clear(var os: ogg_stream_state): int; cdecl; external OGGLIB;
function ogg_stream_packetin(var os: ogg_stream_state; var op: ogg_packet): int; cdecl; external OGGLIB;
function ogg_stream_flush(var os: ogg_stream_state; var og: ogg_page): int; cdecl; external OGGLIB;
function ogg_stream_pageout(var os: ogg_stream_state; var og: ogg_page): int; cdecl; external OGGLIB;
function ogg_page_eos(var og: ogg_page): int; cdecl; external OGGLIB;

// functions of vorbis.dll
procedure vorbis_info_init(var vi: vorbis_info); cdecl; external VORBISLIB;
procedure vorbis_info_clear(var vi: vorbis_info); cdecl; external VORBISLIB;
procedure vorbis_comment_init(var vc: vorbis_comment); cdecl; external VORBISLIB;
procedure vorbis_comment_add(var vc: vorbis_comment; comment: PChar); cdecl; external VORBISLIB;
procedure vorbis_comment_add_tag(var vc: vorbis_comment; tag: PChar; contents: PChar); cdecl; external VORBISLIB;
procedure vorbis_comment_clear(var vc: vorbis_comment); cdecl; external VORBISLIB;
function vorbis_analysis_init(var v: vorbis_dsp_state; var vi: vorbis_info): int; cdecl; external VORBISLIB;
function vorbis_analysis_headerout(var v: vorbis_dsp_state; var vc: vorbis_comment; var op: ogg_packet; var op_comm: ogg_packet; var op_code: ogg_packet): int; cdecl; external VORBISLIB;
function vorbis_analysis_buffer(var v: vorbis_dsp_state; vals: int): ppfloat; cdecl; external VORBISLIB;
function vorbis_analysis_wrote(var v: vorbis_dsp_state; vals: int): int; cdecl; external VORBISLIB;
function vorbis_analysis_blockout(var v: vorbis_dsp_state; var vb: vorbis_block): int; cdecl; external VORBISLIB;
function vorbis_analysis(var vb: vorbis_block; var op: ogg_packet): int; cdecl; external VORBISLIB;
function vorbis_block_init(var v: vorbis_dsp_state; var vb: vorbis_block): int; cdecl; external VORBISLIB;
function vorbis_block_clear(var vb: vorbis_block): int; cdecl; external VORBISLIB;
procedure vorbis_dsp_clear(var v: vorbis_dsp_state); cdecl; external VORBISLIB;
function vorbis_bitrate_addblock(var vb: vorbis_block): int; cdecl; external VORBISLIB;
function vorbis_bitrate_flushpacket(var vd: vorbis_dsp_state; var op: ogg_packet): int; cdecl; external VORBISLIB;

// functions of vorbisenc.dll
function vorbis_encode_init(var vi: vorbis_info; channels, rate, max_bitrate, nominal_bitrate, min_bitrate: long): int; cdecl; external VORBISENCLIB;
function vorbis_encode_init_vbr(var vi: vorbis_info; channels: long; rate: long; base_quality: float): int; cdecl; external VORBISENCLIB;

implementation

end.

