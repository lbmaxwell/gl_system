class JournalEntriesController < ApplicationController
  include JournalEntriesHelper
  before_action :set_journal_entry, only: [:show, :edit, :update, :destroy]

  # GET /journal_entries
  # GET /journal_entries.json
  def index
    @journal_entries = JournalEntry.all
  end

  # GET /journal_entries/1
  # GET /journal_entries/1.json
  def show
  end

  # GET /journal_entries/new
  def new
    @journal_entry = JournalEntry.new
    @today = Date.today.strftime("%Y-%m-%d")
    @accounts = Account.all # TODO - Optimize this query
    @periods = Periods.where(open: true)
 end

  # GET /journal_entries/1/edit
  def edit
  end

  # POST /journal_entries
  # POST /journal_entries.json
  def create
    @accounts = Account.all # TODO - Optimize this query
    @journal_entry = JournalEntry.new(journal_entry_params)
    totals = calculate_je_line_totals(@journal_entry.je_lines)
    @journal_entry.debit_total = totals[:debit]
    @journal_entry.credit_total = totals[:credit]

    #TODO - Everything below this line needs to be updated. Created during initial form creation
    @journal_entry.updated_by = 1
    @journal_entry.created_by = 1
    @journal_entry.period_id = 10
 
    respond_to do |format|
      if @journal_entry.save
        format.html { redirect_to @journal_entry, notice: 'Journal entry was successfully created.' }
        format.json { render :show, status: :created, location: @journal_entry }
      else
        format.html { render :new }
        format.json { render json: @journal_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /journal_entries/1
  # PATCH/PUT /journal_entries/1.json
  def update
    respond_to do |format|
      if @journal_entry.update(journal_entry_params)
        format.html { redirect_to @journal_entry, notice: 'Journal entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @journal_entry }
      else
        format.html { render :edit }
        format.json { render json: @journal_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /journal_entries/1
  # DELETE /journal_entries/1.json
  def destroy
    @journal_entry.destroy
    respond_to do |format|
      format.html { redirect_to journal_entries_url, notice: 'Journal entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_journal_entry
      @journal_entry = JournalEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def journal_entry_params
#      params.require(:journal_entry).permit!
      params.require(:journal_entry).permit(:je_number, :accounting_date, :description,
                                            :updated_by, :created_by, :debit_total, :credit_total,
                                            :period_id, :je_lines_attributes => [:id, :account_id, :debit_amount, 
                                                                      :credit_amount, :period_id, :_destroy])
    end
end
