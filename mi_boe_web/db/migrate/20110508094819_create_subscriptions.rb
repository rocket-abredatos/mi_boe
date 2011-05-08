class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.references :user
      t.string :keywords

      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
