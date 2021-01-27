import 'dart:math' as math;
enum Tramp {
  s01,
  s02,
  s03,
  s04,
  s05,
  s06,
  s07,
  s08,
  s09,
  s10,
  s11,
  s12,
  s13,
  h01,
  h02,
  h03,
  h04,
  h05,
  h06,
  h07,
  h08,
  h09,
  h10,
  h11,
  h12,
  h13,
  c01,
  c02,
  c03,
  c04,
  c05,
  c06,
  c07,
  c08,
  c09,
  c10,
  c11,
  c12,
  c13,
  d01,
  d02,
  d03,
  d04,
  d05,
  d06,
  d07,
  d08,
  d09,
  d10,
  d11,
  d12,
  d13,
  joker1,
  joker2,
  back,
}

String getImgPath(Tramp tramp) {
  String path = "assets/img/card_";

  switch (tramp) {
    case Tramp.back:
      return path + "back.png";
    case Tramp.joker1:
      return path + "joker.png";
    case Tramp.joker2:
      return path + "joker.png";
    case Tramp.s01:
      return path + "spade_01.png";
    case Tramp.s02:
      return path + "spade_02.png";
    case Tramp.s03:
      return path + "spade_03.png";
    case Tramp.s04:
      return path + "spade_04.png";
    case Tramp.s05:
      return path + "spade_05.png";
    case Tramp.s06:
      return path + "spade_06.png";
    case Tramp.s07:
      return path + "spade_07.png";
    case Tramp.s08:
      return path + "spade_08.png";
    case Tramp.s09:
      return path + "spade_09.png";
    case Tramp.s10:
      return path + "spade_10.png";
    case Tramp.s11:
      return path + "spade_11.png";
    case Tramp.s12:
      return path + "spade_12.png";
    case Tramp.s13:
      return path + "spade_13.png";
    case Tramp.h01:
      return path + "heart_01.png";
    case Tramp.h02:
      return path + "heart_02.png";
    case Tramp.h03:
      return path + "heart_03.png";
    case Tramp.h04:
      return path + "heart_04.png";
    case Tramp.h05:
      return path + "heart_05.png";
    case Tramp.h06:
      return path + "heart_06.png";
    case Tramp.h07:
      return path + "heart_07.png";
    case Tramp.h08:
      return path + "heart_08.png";
    case Tramp.h09:
      return path + "heart_09.png";
    case Tramp.h10:
      return path + "heart_10.png";
    case Tramp.h11:
      return path + "heart_11.png";
    case Tramp.h12:
      return path + "heart_12.png";
    case Tramp.h13:
      return path + "heart_13.png";
    case Tramp.c01:
      return path + "club_01.png";
    case Tramp.c02:
      return path + "club_02.png";
    case Tramp.c03:
      return path + "club_03.png";
    case Tramp.c04:
      return path + "club_04.png";
    case Tramp.c05:
      return path + "club_05.png";
    case Tramp.c06:
      return path + "club_06.png";
    case Tramp.c07:
      return path + "club_07.png";
    case Tramp.c08:
      return path + "club_08.png";
    case Tramp.c09:
      return path + "club_09.png";
    case Tramp.c10:
      return path + "club_10.png";
    case Tramp.c11:
      return path + "club_11.png";
    case Tramp.c12:
      return path + "club_12.png";
    case Tramp.c13:
      return path + "club_13.png";
    case Tramp.d01:
      return path + "diamond_01.png";
    case Tramp.d02:
      return path + "diamond_02.png";
    case Tramp.d03:
      return path + "diamond_03.png";
    case Tramp.d04:
      return path + "diamond_04.png";
    case Tramp.d05:
      return path + "diamond_05.png";
    case Tramp.d06:
      return path + "diamond_06.png";
    case Tramp.d07:
      return path + "diamond_07.png";
    case Tramp.d08:
      return path + "diamond_08.png";
    case Tramp.d09:
      return path + "diamond_09.png";
    case Tramp.d10:
      return path + "diamond_10.png";
    case Tramp.d11:
      return path + "diamond_11.png";
    case Tramp.d12:
      return path + "diamond_12.png";
    case Tramp.d13:
      return path + "diamond_13.png";
  }
}

int getNumber(Tramp tramp) {
  int result = -1;
  switch (tramp) {
    case Tramp.joker1:
    case Tramp.joker2:
      result = 0;
      break;
    case Tramp.back:
      result = -1;
      break;
    default:
      result = tramp.index % 13 + 1;
      break;
  }
  print("tramp: $tramp, result: $result");
  return result;
}
