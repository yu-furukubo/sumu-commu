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