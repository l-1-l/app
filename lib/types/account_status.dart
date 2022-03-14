import 'package:freezed_annotation/freezed_annotation.dart';

// pub enum AccountStatus {
//     DeregisteringBlack, // 账户同时进入注销期和小黑屋
//     Deregistering,      // 账户进入注销期
//     Frozen,             // 账户冻结
//     Locked,             // 登录异常 账户锁定
//     Stagged,            // 通过了注册验证, 但是没有完善信息
//     ActiveBlack,        // 小黑屋
//     Active,
// }

enum AccountStatus {
  @JsonValue(-4)
  deregisteringBlack,
  @JsonValue(-3)
  deregistering,
  @JsonValue(-2)
  frozen,
  @JsonValue(-1)
  locked,
  @JsonValue(0)
  stagged,
  @JsonValue(1)
  activeBlack,
  @JsonValue(2)
  active,
}
