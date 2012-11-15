class CreateLikelihoods < ActiveRecord::Migration
  def self.up
    create_table :likelihoods do |t|
      t.references :run
      t.references :variable
      t.references :input
      t.decimal :loglikelihood
      t.decimal :n_eff
      t.decimal :weight
      t.decimal :residual

      t.timestamps
    end
  end

  def self.down
    drop_table :likelihoods
  end
end
