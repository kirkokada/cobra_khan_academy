ActiveAdmin.register CSVImporter do
  permit_params :file, :model_name
  actions :new, :create
  config.batch_actions = false
  menu false

  controller do
    def new
      @csv_importer = CSVImporter.new(model_name: params[:model_name])
    end

    def create
      @csv_importer = CSVImporter.new(permitted_params[:csv_importer])
      model_name = permitted_params[:csv_importer][:model_name]
      redirect_path = self.send("admin_#{model_name.downcase.pluralize}_path")
      if @csv_importer.save
        flash[:notice] = "Successfully Imported"
        redirect_to redirect_path
      else
        render :new
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    inputs do
      f.input :file, as: :file
      f.input :model_name, as: :select, collection: ["Topic", "Instructional"]
      f.action :submit, label: "Import"
    end
  end
end
