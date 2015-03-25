require 'rails_helper'

RSpec.describe "CsvImporters", type: :request do
  
  let(:user) { create :user, admin: true }
  let(:valid_csv_path) { Rails.root.join('spec', 'sample_data', 'valid_topics.csv') }
  let(:invalid_csv_path) { Rails.root.join('spec', 'sample_data', 'invalid_topics.csv') }

  describe "uploading a csv" do
    before do 
      sign_in user
      visit new_admin_csv_importer_path
    end

    describe "with invalid data" do
      before do
        attach_file "File", invalid_csv_path
        select "Topic", from: "Model name"
      end

      it "should not create new records" do
        expect { click_button "Import" }.not_to change(Topic, :count)
      end

      describe "after import" do
        before { click_button "Import" }

        it "should display errors" do
          expect(page).to have_selector "ul.errors"  
        end

      end
    end

    describe "with valid data" do
      before do
        attach_file "File", valid_csv_path
        select "Topic", from: "Model name"
      end

      it "should create new records" do
        expect do 
          click_button "Import" 
        end.to change(Topic, :count).by(CSV.read(valid_csv_path).count - 1)
      end

      describe "after import" do
        before { click_button "Import" }

        it "should redirect to admin resource index" do
          expect(page.current_path).to eq admin_topics_path
        end
        
        describe "creating a record manually" do
          before do 
            visit new_admin_topic_path 
            fill_in "Name", with: "Topic 2"
            fill_in "Description", with: "description"
          end

          it "should create a record" do
            expect { click_button "Create Topic" }.to change(Topic, :count).by(1)
          end
        end
      end
    end
  end
end
