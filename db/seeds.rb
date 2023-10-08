Admin.create!(
  name: 'テスト太郎',
  email: 'admin@test',
  password: '111111'
  )

Residence.create!(
  admin_id: '1',
  housing_type: '0',
  name: 'テストマンション',
  address: '東京都架空市適当ヶ丘1-2-3',
  )
Residence.create!(
  admin_id: '1',
  housing_type: '1',
  name: 'テスト町',
  address: '東京都架空市適当ヶ丘',
  )

Member.create!(
  residence_id: '1',
  name: 'テストメンバー1',
  house_address: '101',
  email: 'member1@test',
  password: '111111'
  )

Member.create!(
  residence_id: '2',
  name: 'テストメンバー2',
  house_address: '1-2-4',
  email: 'member2@test',
  password: '111111'
  )

Board.create!(
  residence_id: '2',
  member_id: '1',
  name: 'テスト掲示板',
  body: 'あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波。またそのなかでいっしょになったたくさんのひとたち、ファゼーロとロザーロ、羊飼のミーロや、顔の赤いこどもたち、地主のテーモ、山猫博士のボーガント・デストゥパーゴなど、いまこの暗い巨きな石の建物のなかで考えていると、みんなむかし風のなつかしい青い幻燈のように思われます。',
  is_circular: 'true'
  )

CircularMember.create!(
  board_id: '1',
  member_id: '1',
  is_checked: 'true'
  )