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

Member.create!(
  residence_id: '1',
  name: 'テストメンバー',
  house_address: '101',
  email: 'member@test',
  password: '111111'
  )