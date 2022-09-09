class SongRankModelTransObj {
  int? rankShowSort;

  SongRankModelTransObj({
    this.rankShowSort,
  });

  SongRankModelTransObj.fromJson(Map<String, dynamic> json) {
    rankShowSort = json['rank_show_sort']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['rank_show_sort'] = rankShowSort;
    return data;
  }
}

class SongRankModelTransParamClassmap {
  int? attr0;

  SongRankModelTransParamClassmap({
    this.attr0,
  });

  SongRankModelTransParamClassmap.fromJson(Map<String, dynamic> json) {
    attr0 = json['attr0']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['attr0'] = attr0;
    return data;
  }
}

class SongRankModelTransParamHashOffset {
  int? fileType;
  int? startByte;
  int? startMs;
  String? offsetHash;
  int? endMs;
  int? endByte;

  SongRankModelTransParamHashOffset({
    this.fileType,
    this.startByte,
    this.startMs,
    this.offsetHash,
    this.endMs,
    this.endByte,
  });

  SongRankModelTransParamHashOffset.fromJson(Map<String, dynamic> json) {
    fileType = json['file_type']?.toInt();
    startByte = json['start_byte']?.toInt();
    startMs = json['start_ms']?.toInt();
    offsetHash = json['offset_hash']?.toString();
    endMs = json['end_ms']?.toInt();
    endByte = json['end_byte']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['file_type'] = fileType;
    data['start_byte'] = startByte;
    data['start_ms'] = startMs;
    data['offset_hash'] = offsetHash;
    data['end_ms'] = endMs;
    data['end_byte'] = endByte;
    return data;
  }
}

class SongRankModelTransParam {
  int? cpyGrade;
  int? musicpackAdvance;
  int? cpyLevel;
  String? hashMultitrack;
  SongRankModelTransParamHashOffset? hashOffset;
  SongRankModelTransParamClassmap? classmap;
  int? payBlockTpl;
  int? cpyAttr0;
  int? displayRate;
  String? appidBlock;
  int? display;
  int? cid;

  SongRankModelTransParam({
    this.cpyGrade,
    this.musicpackAdvance,
    this.cpyLevel,
    this.hashMultitrack,
    this.hashOffset,
    this.classmap,
    this.payBlockTpl,
    this.cpyAttr0,
    this.displayRate,
    this.appidBlock,
    this.display,
    this.cid,
  });

  SongRankModelTransParam.fromJson(Map<String, dynamic> json) {
    cpyGrade = json['cpy_grade']?.toInt();
    musicpackAdvance = json['musicpack_advance']?.toInt();
    cpyLevel = json['cpy_level']?.toInt();
    hashMultitrack = json['hash_multitrack']?.toString();
    hashOffset = (json['hash_offset'] != null)
        ? SongRankModelTransParamHashOffset.fromJson(json['hash_offset'])
        : null;
    classmap = (json['classmap'] != null)
        ? SongRankModelTransParamClassmap.fromJson(json['classmap'])
        : null;
    payBlockTpl = json['pay_block_tpl']?.toInt();
    cpyAttr0 = json['cpy_attr0']?.toInt();
    displayRate = json['display_rate']?.toInt();
    appidBlock = json['appid_block']?.toString();
    display = json['display']?.toInt();
    cid = json['cid']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['cpy_grade'] = cpyGrade;
    data['musicpack_advance'] = musicpackAdvance;
    data['cpy_level'] = cpyLevel;
    data['hash_multitrack'] = hashMultitrack;
    if (hashOffset != null) {
      data['hash_offset'] = hashOffset!.toJson();
    }
    if (classmap != null) {
      data['classmap'] = classmap!.toJson();
    }
    data['pay_block_tpl'] = payBlockTpl;
    data['cpy_attr0'] = cpyAttr0;
    data['display_rate'] = displayRate;
    data['appid_block'] = appidBlock;
    data['display'] = display;
    data['cid'] = cid;
    return data;
  }
}

class SongRankModel {
  int? rankCid;
  int? priceSq;
  int? first;
  int? privilegeHigh;
  int? filesize;
  SongRankModelTransParam? transParam;
  int? inlist;
  String? hashHigh;
  int? pkgPriceSq;
  int? bitrateHigh;
  int? payType;
  String? musical;
  String? topicUrl;
  int? failProcess_320;
  int? pkgPrice;
  String? recommendReason;
  String? filename;
  SongRankModelTransObj? transObj;
  String? extname;
  int? lastSort;
  String? the320hash;
  int? audioId;
  String? vstrId;
  int? albumAudioId;
  int? hasAccompany;
  String? extnameSuper;
  int? isfirst;
  int? the320privilege;
  int? sqprivilege;
  int? issue;
  int? payType_320;
  int? m4afilesize;
  int? bitrate;
  String? albumSizableCover;
  int? price;
  int? privilegeSuper;
  int? oldCpy;
  int? failProcessSq;
  int? filesizeHigh;
  String? rpType;
  int? feetype;
  int? price_320;
  String? hash;
  String? mvhash;
  int? privilege;
  String? addtime;
  String? albumId;
  int? sqfilesize;
  int? payTypeSq;
  int? sort;
  int? rpPublish;
  int? duration;
  int? durationHigh;
  int? filesizeSuper;
  String? remark;
  String? sqhash;
  int? failProcess;
  String? topicUrlSq;
  int? the320filesize;
  int? pkgPrice_320;
  int? durationSuper;
  String? topicUrl_320;
  String? zone;
  String? hashSuper;
  int? bitrateSuper;

  String songName = "";
  String singer = "";
  dynamic lyric;

  SongRankModel({
    this.rankCid,
    this.priceSq,
    this.first,
    this.privilegeHigh,
    this.filesize,
    this.transParam,
    this.inlist,
    this.hashHigh,
    this.pkgPriceSq,
    this.bitrateHigh,
    this.payType,
    this.musical,
    this.topicUrl,
    this.failProcess_320,
    this.pkgPrice,
    this.recommendReason,
    this.filename,
    this.transObj,
    this.extname,
    this.lastSort,
    this.the320hash,
    this.audioId,
    this.vstrId,
    this.albumAudioId,
    this.hasAccompany,
    this.extnameSuper,
    this.isfirst,
    this.the320privilege,
    this.sqprivilege,
    this.issue,
    this.payType_320,
    this.m4afilesize,
    this.bitrate,
    this.albumSizableCover,
    this.price,
    this.privilegeSuper,
    this.oldCpy,
    this.failProcessSq,
    this.filesizeHigh,
    this.rpType,
    this.feetype,
    this.price_320,
    this.hash,
    this.mvhash,
    this.privilege,
    this.addtime,
    this.albumId,
    this.sqfilesize,
    this.payTypeSq,
    this.sort,
    this.rpPublish,
    this.duration,
    this.durationHigh,
    this.filesizeSuper,
    this.remark,
    this.sqhash,
    this.failProcess,
    this.topicUrlSq,
    this.the320filesize,
    this.pkgPrice_320,
    this.durationSuper,
    this.topicUrl_320,
    this.zone,
    this.hashSuper,
    this.bitrateSuper,
  });

  SongRankModel.fromJson(Map<String, dynamic> json) {
    rankCid = json['rank_cid']?.toInt();
    priceSq = json['price_sq']?.toInt();
    first = json['first']?.toInt();
    privilegeHigh = json['privilege_high']?.toInt();
    filesize = json['filesize']?.toInt();
    transParam = (json['trans_param'] != null)
        ? SongRankModelTransParam.fromJson(json['trans_param'])
        : null;
    inlist = json['inlist']?.toInt();
    hashHigh = json['hash_high']?.toString();
    pkgPriceSq = json['pkg_price_sq']?.toInt();
    bitrateHigh = json['bitrate_high']?.toInt();
    payType = json['pay_type']?.toInt();
    musical = json['musical']?.toString();
    topicUrl = json['topic_url']?.toString();
    failProcess_320 = json['fail_process_320']?.toInt();
    pkgPrice = json['pkg_price']?.toInt();
    recommendReason = json['recommend_reason']?.toString();
    filename = json['filename']?.toString();
    transObj = (json['trans_obj'] != null)
        ? SongRankModelTransObj.fromJson(json['trans_obj'])
        : null;
    extname = json['extname']?.toString();
    lastSort = json['last_sort']?.toInt();
    the320hash = json['320hash']?.toString();
    audioId = json['audio_id']?.toInt();
    vstrId = json['vstr_id']?.toString();
    albumAudioId = json['album_audio_id']?.toInt();
    hasAccompany = json['has_accompany']?.toInt();
    extnameSuper = json['extname_super']?.toString();
    isfirst = json['isfirst']?.toInt();
    the320privilege = json['320privilege']?.toInt();
    sqprivilege = json['sqprivilege']?.toInt();
    issue = json['issue']?.toInt();
    payType_320 = json['pay_type_320']?.toInt();
    m4afilesize = json['m4afilesize']?.toInt();
    bitrate = json['bitrate']?.toInt();
    // albumSizableCover = json['album_sizable_cover']?.toString();
    String? cover = json['album_sizable_cover']?.toString();
    if (cover != null && cover.isNotEmpty) {
      albumSizableCover = cover.replaceAll(r'{size}/', "");
    }

    price = json['price']?.toInt();
    privilegeSuper = json['privilege_super']?.toInt();
    oldCpy = json['old_cpy']?.toInt();
    failProcessSq = json['fail_process_sq']?.toInt();
    filesizeHigh = json['filesize_high']?.toInt();
    rpType = json['rp_type']?.toString();
    feetype = json['feetype']?.toInt();
    price_320 = json['price_320']?.toInt();
    hash = json['hash']?.toString();
    mvhash = json['mvhash']?.toString();
    privilege = json['privilege']?.toInt();
    addtime = json['addtime']?.toString();
    albumId = json['album_id']?.toString();
    sqfilesize = json['sqfilesize']?.toInt();
    payTypeSq = json['pay_type_sq']?.toInt();
    sort = json['sort']?.toInt();
    rpPublish = json['rp_publish']?.toInt();
    duration = json['duration']?.toInt();
    durationHigh = json['duration_high']?.toInt();
    filesizeSuper = json['filesize_super']?.toInt();
    remark = json['remark']?.toString();
    sqhash = json['sqhash']?.toString();
    failProcess = json['fail_process']?.toInt();
    topicUrlSq = json['topic_url_sq']?.toString();
    the320filesize = json['320filesize']?.toInt();
    pkgPrice_320 = json['pkg_price_320']?.toInt();
    durationSuper = json['duration_super']?.toInt();
    topicUrl_320 = json['topic_url_320']?.toString();
    zone = json['zone']?.toString();
    hashSuper = json['hash_super']?.toString();
    bitrateSuper = json['bitrate_super']?.toInt();

    if (filename != null && filename!.isNotEmpty) {
      var split = filename!.split("-");
      songName = split.last.trim();
      singer = split.first.trim();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['rank_cid'] = rankCid;
    data['price_sq'] = priceSq;
    data['first'] = first;
    data['privilege_high'] = privilegeHigh;
    data['filesize'] = filesize;
    if (transParam != null) {
      data['trans_param'] = transParam!.toJson();
    }
    data['inlist'] = inlist;
    data['hash_high'] = hashHigh;
    data['pkg_price_sq'] = pkgPriceSq;
    data['bitrate_high'] = bitrateHigh;
    data['pay_type'] = payType;
    data['musical'] = musical;
    data['topic_url'] = topicUrl;
    data['fail_process_320'] = failProcess_320;
    data['pkg_price'] = pkgPrice;
    data['recommend_reason'] = recommendReason;
    data['filename'] = filename;
    if (transObj != null) {
      data['trans_obj'] = transObj!.toJson();
    }
    data['extname'] = extname;
    data['last_sort'] = lastSort;
    data['320hash'] = the320hash;
    data['audio_id'] = audioId;
    data['vstr_id'] = vstrId;
    data['album_audio_id'] = albumAudioId;
    data['has_accompany'] = hasAccompany;
    data['extname_super'] = extnameSuper;
    data['isfirst'] = isfirst;
    data['320privilege'] = the320privilege;
    data['sqprivilege'] = sqprivilege;
    data['issue'] = issue;
    data['pay_type_320'] = payType_320;
    data['m4afilesize'] = m4afilesize;
    data['bitrate'] = bitrate;
    data['album_sizable_cover'] = albumSizableCover;
    data['price'] = price;
    data['privilege_super'] = privilegeSuper;
    data['old_cpy'] = oldCpy;
    data['fail_process_sq'] = failProcessSq;
    data['filesize_high'] = filesizeHigh;
    data['rp_type'] = rpType;
    data['feetype'] = feetype;
    data['price_320'] = price_320;
    data['hash'] = hash;
    data['mvhash'] = mvhash;
    data['privilege'] = privilege;
    data['addtime'] = addtime;
    data['album_id'] = albumId;
    data['sqfilesize'] = sqfilesize;
    data['pay_type_sq'] = payTypeSq;
    data['sort'] = sort;
    data['rp_publish'] = rpPublish;
    data['duration'] = duration;
    data['duration_high'] = durationHigh;
    data['filesize_super'] = filesizeSuper;
    data['remark'] = remark;
    data['sqhash'] = sqhash;
    data['fail_process'] = failProcess;
    data['topic_url_sq'] = topicUrlSq;
    data['320filesize'] = the320filesize;
    data['pkg_price_320'] = pkgPrice_320;
    data['duration_super'] = durationSuper;
    data['topic_url_320'] = topicUrl_320;
    data['zone'] = zone;
    data['hash_super'] = hashSuper;
    data['bitrate_super'] = bitrateSuper;
    return data;
  }
}
