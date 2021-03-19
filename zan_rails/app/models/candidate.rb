class Candidate < ApplicationRecord
    # dependent: :destroy 連動刪除
    has_many :vote_logs, dependent: :destroy
end
