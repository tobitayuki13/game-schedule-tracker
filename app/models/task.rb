class Task < ApplicationRecord
  belongs_to :routine

  enum status: { not_started: 0, in_progress: 1, done: 2 }

  def reset_status!
    update!(status: :not_started)
  end
end
