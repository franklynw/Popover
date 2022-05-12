//
//  NotificationViewController.swift
//  
//
//  Created by Franklyn Weber on 20/02/2021.
//

import SwiftUI


class NotificationViewController: UIViewController {
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    
    var content: PopoverNotificationContent!
    
    private var gradientLayer: CAGradientLayer?
    
    
    static func height(for content: PopoverNotificationContent, inContainerWidth containerWidth: CGFloat) -> CGFloat {
        
        let size = CGSize(width: containerWidth * 0.9, height: .greatestFiniteMagnitude)
        var textHeight: CGFloat = 0
        
        if let font = content.titleFont {
            textHeight = content.title.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height + 22
        } else if let attributedTitle = content.attributedTitle {
            textHeight = attributedTitle.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).height + 22
        }
        
        if let message = content.message {
            
            let size = CGSize(width: containerWidth * 0.9, height: .greatestFiniteMagnitude)
            
            if let font = content.messageFont {
                textHeight += message.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height + 8
            } else if let attributedMessage = content.attributedMessage {
                textHeight += attributedMessage.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).height + 8
            }
        }
        
        return textHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let attributedTitle = content.attributedTitle {
            titleLabel.attributedText = attributedTitle
        } else {
            titleLabel.text = content.title
            titleLabel.font = content.titleFont
        }
        
        if let attributedMessage = content.attributedMessage {
            messageLabel.attributedText = attributedMessage
        } else {
            messageLabel.text = content.message
            messageLabel.font = content.messageFont
        }
        
        switch content.backgroundColor {
        case .flat(let color):
            backgroundView.backgroundColor = color
        case .gradient(let color):
            makeGradient(color)
        case .none:
            break
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if case .gradient(let color) = content.backgroundColor {
            makeGradient(color)
        }
    }
    
    private func makeGradient(_ color: UIColor) {
        
        let gradientLayer: CAGradientLayer
        
        if let layer = self.gradientLayer {
            gradientLayer = layer
        } else {
            gradientLayer = CAGradientLayer()
            backgroundView.layer.addSublayer(gradientLayer)
            self.gradientLayer = gradientLayer
        }
        
        gradientLayer.frame = backgroundView.bounds
        gradientLayer.colors = [color.cgColor, color.withAlphaComponent(0.5).cgColor]
    }
}
