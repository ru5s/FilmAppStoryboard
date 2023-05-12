//
//  RoundingTransition.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 01/03/23.
//

import Foundation
import UIKit

//кастомная анимация появления страницы
class RoundingTransition: NSObject {
    //создание пустого вью
    var round = UIView()
    //точка старта с кложуром на изменения
    var start = CGPoint.zero {
        didSet {
            //центр вью равен точки старта
            round.center = start
        }
    }
    //цвет круга
    var roundColor = UIColor.red
    //время анимации
    var time = 0.6
    //енум для стадий отображения
    enum RoundingTransitionProfile: Int {
        case show, cancel, pop
    }
    //профайл анимации по умолчанию
    var transitionProfile: RoundingTransitionProfile = .show
    
}

//подключаем библиотеку с кастомной анимацией появления страницы
extension RoundingTransition: UIViewControllerAnimatedTransitioning {
    
    //время прохода анимации
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return time
    }
    
    //настройка перехода анимации
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //создание контейнера для элементов
        let container = transitionContext.containerView
        //при запуске этого контейнера
        if transitionProfile == .show {
            //при запуске анимации создаем константу которая скажет что происходит на данный момент (открытие или сворачивание
            if let showedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                //находим центр контейнера
                let viewCenter = showedView.center
                //находим размер контейнера
                let viewSize = showedView.frame.size
                //создаем круг вью для первоначального появления
                round = UIView()
                //с помощью метода ниже получаем размер элемента
                round.frame = roundFrame(withViewCenter: viewCenter, size: viewSize, startPoint: start)
                //делаем вью круглям, скругляя угол на половину ширины
                round.layer.cornerRadius = round.frame.size.height / 2
                //задаем ему центр
                round.center = start
                //задаем цвет фона
                round.backgroundColor = roundColor
                //трансформируем его уменьшая scale
                round.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                //добавляем в контейнер этот вью
                container.addSubview(round)
                
                //указыаем главному вью центр
                showedView.center = start
                //задаем размер
                showedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                //прозрачность
                showedView.alpha = 0
                //добавляем в контейнер
                container.addSubview(showedView)
                
                //производим анимацию
                UIView.animate(withDuration: time, animations: {
                    self.round.transform = CGAffineTransform.identity
                    showedView.transform = CGAffineTransform.identity
                    showedView.alpha = 1
                    showedView.center = viewCenter
                    
                }, completion: {(success: Bool) in
                    transitionContext.completeTransition(success)
                })
            }
            
        } else {
            //в случае сворачивании изменить профиль и произвести анимацию в обратную сторону
            let transitionModeKey = (transitionProfile == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            //проверяем что профиль выбран правильный
            if let returnableView = transitionContext.view(forKey: transitionModeKey) {
                
                let viewCenter = returnableView.center
                let viewSize = returnableView.frame.size
                
                round.frame = roundFrame(withViewCenter: viewCenter, size: viewSize, startPoint: start)
                
                round.layer.cornerRadius = round.frame.size.height / 2
                round.center = start
                
                //производим анимацию
                UIView.animate(withDuration: time, animations: {
                    
                    self.round.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returnableView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returnableView.center = self.start
                    returnableView.alpha = 0
                    //меняем сабвью с кругом местами с вью с данными
                    if self.transitionProfile == .pop {
                        container.insertSubview(returnableView, belowSubview: returnableView)
                        container.insertSubview(self.round, belowSubview: returnableView)
                    }
                    
                }, completion: { (success: Bool) in
                    returnableView.center = viewCenter
                    //после отработки удаляем его из главного списка
                    returnableView.removeFromSuperview()
                    //так же и круг удаляем из главного списка
                    self.round.removeFromSuperview()
                    
                    transitionContext.completeTransition(success)
                })
            }
        }
    }
    
    //метод получения размера прямоугольника
    func roundFrame(withViewCenter viewCenter: CGPoint, size viewsize: CGSize, startPoint:CGPoint) -> CGRect {
        //находим ширину путем максимальной входящей цифры из двух входящих
        let xLength = fmax(startPoint.x, viewsize.width - startPoint.x)
        //так же находим высоту
        let yLength = fmax(startPoint.y, viewsize.height - startPoint.y)
        //находим квадратный корень из входящих данных и умножаем его на два
        let offsetVector = sqrt(xLength * xLength * yLength * yLength) * 2
        //указываем размер, в данном случае это квадрат
        let size = CGSize(width: offsetVector, height: offsetVector)
        //возвращаем полученные данные
        return CGRect(origin: CGPoint.zero, size: size)
    }
    
}
