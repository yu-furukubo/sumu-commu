class Admin::ReservationsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @residences = current_admin.residences
    @residence_id_array = @residences.pluck(:id)
    @reservations = Reservation.where(residence_id: @residence_id_array).where('finished_at > ?', Time.now).order(started_at: "ASC")
    @reservations_past = Reservation.where(residence_id: @residence_id_array).where('finished_at =< ?', Time.now).order(started_at: "DESC")
  end

  def residence_search
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
    @reservations = @residence.reservations.where('finished_at > ?', Time.now).order(started_at: "ASC")
  end

  def show
    @reservation = Reservation.find(params[:id])
    if @reservation.equipment_id.present?
      @equipment_reserved = @reservation.equipment
    elsif @reservation.facility_id.present?
      @facility_reserved = @reservation.facility
    end
  end

  def new
    @reservation = Reservation.new
  end

  def create
    if params[:reservation][:equipment_id].present?
      reservations = Reservation.where(equipment_id: params[:reservation][:equipment_id])
    elsif params[:reservation][:facility_id].present?
      reservations = Reservation.where(facility_id: params[:reservation][:facility_id])
    end

    @reservation = Reservation.new(reservation_params)
    set_the_day_implement(@reservation)

    if @reservation.started_at > @reservation.finished_at
      flash.now[:notice] = "使用完了日時は、使用開始日時より後の日時を指定してください。"
      render "new"
      return
    end

    if reservations.where('finished_at > ? and ? > started_at', @reservation.started_at, @reservation.finished_at).exists?
      if @reservation.equipment_id.present?
        count = reservations.where('finished_at > ? and ? > started_at', @reservation.started_at, @reservation.finished_at).count
        if @reservation.equipment.stock <= count
          flash.now[:notice] = "その期間には別の予約が入っています。空き時間をご確認ください。"
          render "new"
          return
        else
          @reservation.save
          redirect_to admin_reservation_path(@reservation)
          return
        end
      else
        flash.now[:notice] = "その期間には別の予約が入っています。空き時間をご確認ください。"
        render "new"
        return
      end
    end

    if @reservation.save
      redirect_to admin_reservation_path(@reservation)
    else
      flash.now[:notice] = "予約に失敗しました。"
      render "new"
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])
  end

  def update
    @reservation = Reservation.find(params[:id])

    if @reservation.equipment.present?
      reservations = Reservation.where(equipment_id: @reservation.equipment.id)
    elsif @reservation.facility.present?
      reservations = Reservation.where(facility_id: @reservation.facility.id)
    end

    @reservation = Reservation.find(params[:id])
    set_the_day_implement_edit(@reservation)
    pp "-----------------------------------------------確認",@reservation.started_at,@reservation.finished_at,params[:reservation][:start_at]

    if @reservation.started_at > @reservation.finished_at
      flash.now[:notice] = "使用完了日時は、使用開始日時より後の日時を指定してください。"
      render "edit"
      return
    end

    if reservations.where('finished_at > ? and ? > started_at', @reservation.started_at, @reservation.finished_at).exists?
      count = reservations.where('finished_at > ? and ? > started_at', @reservation.started_at, @reservation.finished_at).count
      if @reservation.equipment_id.present?
        if @reservation.equipment.stock + 1 <= count
          flash.now[:notice] = "その期間には別の予約が入っています。空き時間をご確認ください。"
          render "edit"
          return
        else
          pp "------------------------------------ここ？"
          @reservation.update(reservation_params)
          redirect_to admin_reservation_path(@reservation)
          return
        end
      elsif count > 1
        flash.now[:notice] = "その期間には別の予約が入っています。空き時間をご確認ください。"
        render "edit"
        return
      end
    end
pp "------------------------------------ここ？" , @reservation
    if @reservation.update(reservation_params)
      redirect_to admin_reservation_path(@reservation)
    else
      flash.now[:notice] = "予約内容の更新に失敗しました。"
      render "edit"
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    if @reservation.destroy
      redirect_to admin_reservations_path
    else
      flash.now[:notice] = "予約の削除に失敗しました。"
      if @reservation.equipment_id.present?
        @equipment_reserved = @reservation.equipment
      elsif @reservation.facility_id.present?
        @facility_reserved = @reservation.facility
      end
      render "show"
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:residence_id, :member_id, :equipment_id, :facility_id, :start_date, :started_at, :finish_date, :finished_at, :using_status)
  end

  def set_the_day_implement(reservation)
    start_year = reservation.start_date.year
    start_month = reservation.start_date.month
    start_day = reservation.start_date.day
    finish_year = reservation.finish_date.year
    finish_month = reservation.finish_date.month
    finish_day = reservation.finish_date.day

    reservation.started_at = reservation.started_at.change(year: start_year, month: start_month, day: start_day)
    reservation.finished_at = reservation.finished_at.change(year: finish_year, month: finish_month, day: finish_day)
  end

  def set_the_day_implement_edit(reservation)
    start_year = params[:reservation][:start_date].to_date.year
    start_month = params[:reservation][:start_date].to_date.month
    start_day = params[:reservation][:start_date].to_date.day
    finish_year = params[:reservation][:finish_date].to_date.year
    finish_month = params[:reservation][:finish_date].to_date.month
    finish_day = params[:reservation][:finish_date].to_date.day
    finish_hour = params[:reservation][:finished_at].to_time.hour
    finish_minute = params[:reservation][:finished_at].to_time.minute

    reservation.started_at = reservation.started_at.change(year: start_year, month: start_month, day: start_day)
    reservation.finished_at = reservation.finished_at.change(year: finish_year, month: finish_month, day: finish_day, hour: finish_hour, minute: finish_minute)
  end

end
