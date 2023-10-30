import 'package:freezed_annotation/freezed_annotation.dart';

import '../../net_models/bill/bill_data_dto.dart';
import '../user/public_profile.dart';
import 'item_group.dart';
import 'modules/bill_module_tax.dart';
import 'modules/bill_module_tip.dart';

part 'bill_data.freezed.dart';

@unfreezed
class BillData with _$BillData {
  @Assert('totalSpent >= 0')
  factory BillData({
    required DateTime dateTime,
    @Default("New Bill") String name,
    @Default(0) double totalSpent,
    PublicProfile? payer,
    List<PublicProfile>? primarySplits,
    List<PublicProfile>? secondarySplits,
    List<(PublicProfile, double)>? paymentResolveStatuses,
    //
    required List<ItemGroup> itemGroups,
    required BillModule_Tax taxModule,
    required BillModule_Tip tipModule,
    required DateTime lastUpdatedSession,
  }) = _BillData;

  BillData._();

  BillDataDTO get toDataTransferObj => BillDataDTO(
        dateTime: dateTime,
        name: name,
        totalSpent: totalSpent,
        payerUid: payer!.uid,
        lastUpdatedSession: lastUpdatedSession,
      );
}
//TODO: when a new item is added, initialized its tax list with the current number of taxes
//TODO: when a new tax is introduced, iterate through all the items and update their List<bool>