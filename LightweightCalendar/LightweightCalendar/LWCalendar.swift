import Foundation
import UIKit

class LWCalendar: UIView
{
    var monthLabel: UILabel = UILabel()
    fileprivate var calendar: LWCalendarCollectionView?
    weak var delegate: LWCalendarDelegate?

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        loadCalendar()
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        loadCalendar()
    }

    func loadCalendar()
    {
        self.clipsToBounds = true
        calendar = LWCalendarCollectionView(frame: CGRect.zero)
        guard let calendar = calendar else { return }
        self.addSubview(calendar)
        loadMonthLabel(calendar: calendar)

        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.clipsToBounds = true
        NSLayoutConstraint.init(item: calendar,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: monthLabel,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: calendar,
                                attribute: .left,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .left,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: calendar,
                                attribute: .right,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .right,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: calendar,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0).isActive = true

        //GESTURE RECOGNIZERS
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
    }

    fileprivate func loadMonthLabel(calendar: LWCalendarCollectionView)
    {
        self.monthLabel.removeFromSuperview()
        monthLabel = UILabel()
        self.addSubview(monthLabel)
        monthLabel.frame = CGRect.zero
        monthLabel.textAlignment = .center
        setMonthLabelWith(date: calendar.selectedDate)
        monthLabel.center = CGPoint(x: 0, y: 0)
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.init(item: monthLabel,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: monthLabel,
                                attribute: .left,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .left,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: monthLabel,
                                attribute: .right,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .right,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: monthLabel,
                                attribute: .height,
                                relatedBy: .equal,
                                toItem: nil,
                                attribute: .notAnAttribute,
                                multiplier: 1,
                                constant: 35).isActive = true
    }

    func setMonthLabelWith(date: Date)
    {
        monthLabel.text = Utils.shared.months[Utils.shared.getDateComponentsFrom(date: date).month!]
        monthLabel.text = monthLabel.text! + " " + String(Utils.shared.getDateComponentsFrom(date: date).year!)
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void
    {
        UIView.animate(withDuration: 0.15)
        {
            self.calendar?.alpha = 0.0
            self.monthLabel.alpha = 0.0
        }
        if gesture.direction == .right
        {
            calendar?.shiftByMonth(forward: false)
        }
        else if gesture.direction == .left
        {
            calendar?.shiftByMonth(forward: true)
        }
        UIView.animate(withDuration: 0.15, delay: 0.15, options: [], animations:
            {
                self.calendar?.alpha = 1.0
                self.monthLabel.alpha = 1.0
        }, completion: nil)
    }

    func setDate(_ date: Date)
    {
        calendar?.selectedDate = date
        calendar?.loadData(size: CGSize(width: self.frame.size.width / 7, height: self.frame.size.height / 7))
    }

}

protocol LWCalendarDelegate: class
{
    func viewFor(date: Date, with components: DateComponents, of size: CGSize) -> UIView?
    func viewForSelectedDate(of size: CGSize) -> UIView?
    func didSelectDayAt(date: Date, with components: DateComponents)
}

private class LWCalendarCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    var dataSource: [Month] = []
    var selectedDate: Date = Date()
    var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var selectedDayView: UIView?

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(Day.self, forCellWithReuseIdentifier: "DayCell")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        (size: CGSize(width: frame.size.width / 7, height: frame.size.height / 7))
        collectionView.backgroundColor = .white

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.init(item: collectionView,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: collectionView,
                                attribute: .left,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .left,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: collectionView,
                                attribute: .right,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .right,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: collectionView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0).isActive = true
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    func loadData(size: CGSize)
    {
        selectedDayView = (superview as? LWCalendar)?.delegate?.viewForSelectedDate(of: size)
        let selectedDateComponents = Utils.shared.getDateComponentsFrom(date: selectedDate)
        let currentMonthDate = Utils.shared.getDateFrom(day: selectedDateComponents.day!,
                                                        month: selectedDateComponents.month!,
                                                        year: selectedDateComponents.year!)

        let currentMonth: Month = Month()
        (superview as? LWCalendar)?.setMonthLabelWith(date: selectedDate)

        //WEEKDAY LABELS FROM MONDAY TO SUNDAY
        for i in 1..<8
        {
            currentMonth.days.append((Day(number: i, isWeekday: true)))
        }

        //CELLS BEFORE THE FIRST DAY OF THE MONTH (LAST DAYS FROM THE PREVIOUS MONTH)
        let firstWeekday = Utils.shared.getWeekdayFrom(date: Utils.shared.getDateFrom(day: 1,
                                                                                      month: selectedDateComponents.month!,
                                                                                      year: selectedDateComponents.year!)!)
        var previousMonthNumOfDays = Utils.shared.getNumberOfMonthDaysFrom(date: Utils.shared.getDateFrom(day: 10,
                                                                                                          month: selectedDateComponents.month! - 1,
                                                                                                          year: selectedDateComponents.year!)!)
        previousMonthNumOfDays -= firstWeekday!.0 - 1
        for _ in 0..<(firstWeekday!.0 - 1)
        {
            previousMonthNumOfDays += 1
            currentMonth.days.append(Day(foregroundColor: .lightGray,
                                         number: previousMonthNumOfDays,
                                         isWeekday: false))
        }

        //CURRENT MONTH DAY LABELS
        for i in 0..<Utils.shared.getNumberOfMonthDaysFrom(date: currentMonthDate!)
        {
            currentMonth.days.append(Day(number: i + 1,
                                         isWeekday: false,
                                         date: Utils.shared.getDateFrom(day: i + 1,
                                                                        month: selectedDateComponents.month!,
                                                                        year: selectedDateComponents.year!)))
        }

        //CELLS AFTER THE FIRST DAY OF THE MONTH
        if currentMonth.days.count <= 42
        {
            for i in 0..<(42 - currentMonth.days.count)
            {
                currentMonth.days.append(Day(foregroundColor: .lightGray,
                                             number: i + 1,
                                             isWeekday: false))
            }
        }

        dataSource.removeAll()
        dataSource.append(currentMonth)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    //COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width / 7, height: collectionView.frame.height / 7)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (dataSource.first?.days.count)!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as? Day
        {
            cell.backgroundView = nil
            cell.backgroundColor = .white
            if let date = dataSource[0].days[indexPath.row].date,
                let viewForDay = (superview as? LWCalendar)?.delegate?.viewFor(date: date,
                                                                               with: Utils.shared.getDateComponentsFrom(date: date),
                                                                               of: cell.frame.size)
            {
                cell.backgroundView = viewForDay
            }
            cell.foregroundColor = dataSource[0].days[indexPath.row].foregroundColor
            cell.number = dataSource[0].days[indexPath.row].number
            cell.addLabel()
            cell.dayName.text = dataSource[0].days[indexPath.row].dayName.text
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let date = dataSource[0].days[indexPath.row].date
        {
            (superview as? LWCalendar)?.delegate?.didSelectDayAt(date: date, with: Utils.shared.getDateComponentsFrom(date: date))
            if let selectedView = selectedDayView
            {
                for item in collectionView.visibleCells
                {
                    (item as! Day).backgroundView = nil
                }
                (collectionView.cellForItem(at: indexPath) as! Day).backgroundView = selectedView
            }
        }
    }

    func shiftByMonth(forward: Bool)
    {
        let selectedDateComponents = Utils.shared.getDateComponentsFrom(date: selectedDate)
        var newMonth: Int = forward ? selectedDateComponents.month! + 1 : selectedDateComponents.month! - 1
        var newYear: Int = selectedDateComponents.year!
        if newMonth < 1
        {
            newYear -= 1
            newMonth = 12
        }
        if newMonth > 12
        {
            newYear += 1
            newMonth = 1
        }
        selectedDate = Utils.shared.getDateFrom(day: 10, month: newMonth, year: newYear)!
        loadData(size: CGSize(width: self.frame.size.width / 7, height: self.frame.size.height / 7))
    }

}

private class Month
{
    var days: [Day] = []

    init() {}

    init(days: [Day])
    {
        self.days.removeAll()
        self.days = days
    }

}

private class Day: UICollectionViewCell
{
    var foregroundColor: UIColor = .black
    var number: Int?
    var dayName: UILabel = UILabel()
    var date: Date?

    init(backgroundColor: UIColor = .clear, foregroundColor: UIColor = .black, number: Int?, isWeekday: Bool = false, date: Date? = nil)
    {
        self.number = number
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor

        guard let number = number else { return }
        if isWeekday, let weekday = Utils.shared.getWeekdayFrom(number: number)
        {
            self.dayName.text = weekday
        }
        else
        {
            self.dayName.text = String(number)
        }
        self.date = date
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func addLabel()
    {
        self.addSubview(dayName)
        dayName.textColor = self.foregroundColor
        dayName.textAlignment = .center
        dayName.adjustsFontSizeToFitWidth = true
        dayName.minimumScaleFactor = 0.2
        Utils.shared.stretch(insideView: dayName, toContainerView: self)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

}

private class Utils
{
    let months: [Int: String] = [1: "January",
                                 2: "February",
                                 3: "March",
                                 4: "April",
                                 5: "May",
                                 6: "June",
                                 7: "July",
                                 8: "August",
                                 9: "September",
                                 10: "October",
                                 11: "November",
                                 12: "December"]
    let weekdays: [Int: String] = [1: "Su", 2: "Mo", 3: "Tu", 4: "We", 5: "Th", 6: "Fr", 7: "Sa"]
    class var shared: Utils
    {
        struct Singleton
        {
            static let instance = Utils()
        }
        return Singleton.instance
    }

    func getWeekdayFrom(date: Date) -> (Int, String)?
    {
        guard let weekday = Calendar.current.dateComponents([.weekday], from: date).weekday else { return nil }
        return (weekday, weekdays[weekday]) as? (Int, String)
    }

    func getWeekdayFrom(number: Int) -> String?
    {
        if number >= 1 && number < 8
        {
            return weekdays[number]
        }
        return nil
    }

    func getNumberOfMonthDaysFrom(date: Date) -> Int
    {
        let range = Calendar.current.range(of: .day, in: .month, for: date)
        guard let days = range else { return 0 }
        return days.count
    }

    func getDateFrom(day: Int, month: Int, year: Int) -> Date?
    {
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(abbreviation: "GMT")
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return Calendar.current.date(from: dateComponents)
    }

    func getDateComponentsFrom(date: Date) -> DateComponents
    {
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(abbreviation: "GMT")
        dateComponents.year = Calendar.current.component(.year, from: date)
        dateComponents.month = Calendar.current.component(.month, from: date)
        dateComponents.day = Calendar.current.component(.day, from: date)
        return dateComponents
    }

    func stretch(insideView: UIView, toContainerView: UIView)
    {
        insideView.frame = CGRect(x: 0, y: 0, width: toContainerView.frame.width, height: toContainerView.frame.height)
    }

}
