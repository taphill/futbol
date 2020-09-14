require 'csv'

class Manager
  attr_reader :manager

  def initialize(csv_file_path, manager_type)
    @manager = create_manager(csv_file_path, manager_type)
  end

  def from_csv(csv_file_path)
    CSV.foreach(csv_file_path, headers: true,)
  end

  def create_manager

  end
end
