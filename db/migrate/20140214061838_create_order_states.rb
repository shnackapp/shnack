class CreateOrderStates < ActiveRecord::Migration
  def change
    create_table :order_states do |t|
      t.integer :order_id
      t.integer :state

      t.timestamps
    end

    Order.all.each { |o| o.order_states.create(:state => 0)  }

  end
end
