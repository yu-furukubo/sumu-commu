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

Member.create!(
  residence_id: '1',
  name: 'テストメンバー3',
  house_address: '305',
  email: 'member3@test',
  password: '111111'
  )

Board.create!(
  residence_id: '1',
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

Community.create!(
  residence_id: '1',
  member_id: '3',
  name: 'テストコミュニティ',
  description: 'テスト用に作成したコミュニティです。'
  )

CommunityMember.create!(
  community_id: '1',
  member_id: '1',
  is_admin: 'true'
  )

CommunityMember.create!(
  community_id: '1',
  member_id: '3',
  is_admin: 'false'
  )

CommunityComment.create!(
  community_id: '1',
  member_id: '1',
  comment: 'テストコメント'
  )

CommunityComment.create!(
  community_id: '1',
  member_id: '3',
  comment: 'テストコメント2'
  )

Event.create!(
  residence_id: '1',
  member_id: '0',
  name: 'テストイベント',
  description: 'テスト用に作成したイベントです。',
  started_at: '2023-10-10 09:00:00',
  finished_at: '2023-10-10 18:00:00',
  venue: 'エントランス脇スペース'
  )

EventMember.create!(
  event_id: '1',
  member_id: '1',
  is_admin: 'false'
  )

EventMember.create!(
  event_id: '1',
  member_id: '3',
  is_admin: 'false'
  )

exchange1 = Exchange.new(
  residence_id: '1',
  member_id: '1',
  name: 'テストゆずりあい',
  description: 'テスト用に作成したゆずりあいです。',
  price: '1000',
  deadline: '2023-10-10 18:00:00',
  is_finished: 'true'
)
exchange1.exchange_item_images.attach(io: File.open(Rails.root.join('app/assets/images/curryplanet.jpg')), filename: 'curryplanet.jpg')
exchange1.save!

Exchange.create!(
  residence_id: '1',
  member_id: '3',
  name: 'テストゆずりあい2',
  description: 'テスト用に作成したゆずりあいその２です。',
  price: '0',
  deadline: '2023-11-10 18:00:00',
  is_finished: 'false'
)

ExchangeComment.create!(
  exchange_id: '1',
  member_id: '3',
  comment: 'ほしいです！'
  )