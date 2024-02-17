import UIKit
import SnapKit

class LoginViewController: UIViewController {

    // MARK: - Properties -

    static let mainScreenBounds = UIScreen.main.bounds
    static let mainScreenWidth = mainScreenBounds.width
    static let mainScreenHeight = mainScreenBounds.height

    // View model responsible for the login logic
    private let viewModel = LoginViewModel()

    // MARK: - UI Elements -

    private lazy var loginTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Login"
        label.textColor = ColorPalette.defaultTitleLable
        label.font = UIFont.systemFont(ofSize: FontSize.titleLabel, weight: .bold)
        return label
    }()

    private lazy var labelLogin: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        customizeLabelAboveTextField(label, text: "Username", ofSize: FontSize.labelAboveTextField)
        return label
    }()

    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        customizeTextField(textField, placeholder: "Username")
        return textField
    }()

    private lazy var labelPassword: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        customizeLabelAboveTextField(label, text: "Password", ofSize: FontSize.labelAboveTextField)
        return label
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        customizeTextField(textField, placeholder: "Password")
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorPalette.buttonBackground
        button.layer.cornerRadius = Self.mainScreenHeight * LayoutMetrics.cornerRadiusButtonMultiplier
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.loginButton, weight: .black)
        button.setTitleColor(ColorPalette.buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        bindViewModel()
    }

    // MARK: - Setups -

    private func setupView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [ColorPalette.gradientStartColor.cgColor, ColorPalette.gradientEndColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.5)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupHierarchy() {
        [
            loginTitleLabel,
            labelLogin,
            loginTextField,
            labelPassword,
            passwordTextField,
            loginButton,
        ].forEach{ view.addSubview($0) }
    }

    private func setupLayout() {
        let centerYOffsetTitleLabel = Self.mainScreenHeight * LayoutMetrics.centerYOffsetTitleLabelMultiplier
        let topMarginLoginLabel = Self.mainScreenHeight * LayoutMetrics.topMarginLoginLabelMultiplier
        let topMarginPasswordLabel = Self.mainScreenHeight * LayoutMetrics.topMarginPasswordLabelMultiplier
        let leadingMarginLabel = Self.mainScreenWidth * LayoutMetrics.leadingMarginLabelMultiplier
        let topMarginTextField = Self.mainScreenHeight * LayoutMetrics.topMarginTextFieldMultiplier
        let leadingTrailingMarginTextField = Self.mainScreenWidth * LayoutMetrics.leadingTrailingMarginTextFieldMultiplier
        let heightMarginTextField = Self.mainScreenHeight * LayoutMetrics.heightMarginTextFieldMultiplier
        let topMarginButton = Self.mainScreenHeight * LayoutMetrics.topMarginButtonMultiplier
        let leadingTrailingMarginButton = Self.mainScreenWidth * LayoutMetrics.leadingTrailingMarginButtonMultiplier
        let heightMarginButton = Self.mainScreenHeight * LayoutMetrics.heightMarginButtonMultiplier

        loginTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(centerYOffsetTitleLabel)
        }

        labelLogin.snp.makeConstraints { make in
            make.top.equalTo(loginTitleLabel.snp.bottom).offset(topMarginLoginLabel)
            make.leading.equalToSuperview().offset(leadingMarginLabel)
        }

        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(labelLogin.snp.bottom).offset(topMarginTextField)
            make.leading.equalToSuperview().offset(leadingTrailingMarginTextField)
            make.trailing.equalToSuperview().offset(-leadingTrailingMarginTextField)
            make.height.equalTo(heightMarginTextField)
        }

        labelPassword.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(topMarginPasswordLabel)
            make.leading.equalToSuperview().offset(leadingMarginLabel)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(labelPassword.snp.bottom).offset(topMarginTextField)
            make.leading.equalToSuperview().offset(leadingTrailingMarginTextField)
            make.trailing.equalToSuperview().offset(-leadingTrailingMarginTextField)
            make.height.equalTo(heightMarginTextField)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(topMarginButton)
            make.leading.equalToSuperview().offset(leadingTrailingMarginButton)
            make.trailing.equalToSuperview().offset(-leadingTrailingMarginButton)
            make.height.equalTo(heightMarginButton)
        }
    }

    // MARK: - Action -

    @objc
    private func loginButtonPressed() {
        guard let username = loginTextField.text, let password = passwordTextField.text,
              !username.isEmpty, !password.isEmpty else {
            showAlert(title: "ОШИБКА", message: "Введите логин и пароль!")
            return
        }
        // Initiation of authentication process
        viewModel.authenticate(username: username, password: password)
    }

    // MARK: - Combine

    // Bind view model properties to UI elements
    private func bindViewModel() {

        // Bind statusText to loginTitleLabel text property
        viewModel.$selectedText
            .compactMap { $0 }                        // Use compactMap to filter out optional values (nil) from the publisher
            .assign(to: \.text, on: loginTitleLabel)  // Assign the non-nil values to the 'text' property of loginTitleLabel
            .store(in: &viewModel.cancellables)       // Store the cancellable returned by assign(in:) in the cancellables set

        // Bind selectedColor to loginTitleLabel textColor property
        viewModel.$selectedColor
            .compactMap { $0 }
            .assign(to: \.textColor, on: loginTitleLabel)
            .store(in: &viewModel.cancellables)
    }

    // MARK: - Func -

    private func customizeTextField(_ textField: UITextField, placeholder: String) {
        textField.backgroundColor = .white
        textField.layer.cornerRadius = Self.mainScreenHeight * LayoutMetrics.cornerRadiusTextFieldMultiplier
        textField.textColor = ColorPalette.textField
        textField.textAlignment = .left
        textField.placeholder = placeholder
        textField.autocapitalizationType = .none

        let indentSize = Self.mainScreenWidth * LayoutMetrics.indentTextFieldForMultiplier
        textField.indent(size: indentSize)
    }

    private func customizeLabelAboveTextField(_ label: UILabel, text: String, ofSize: CGFloat) {
        label.text = text
        label.textColor = ColorPalette.textLabelAboveTextField
        label.font = UIFont.systemFont(ofSize: ofSize, weight: .regular)
        label.textAlignment = .left
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController {
    private enum LayoutMetrics {
        static let centerYOffsetTitleLabelMultiplier: CGFloat = -0.35
        static let topMarginLoginLabelMultiplier: CGFloat = 0.05
        static let topMarginPasswordLabelMultiplier: CGFloat = 0.05
        static let leadingMarginLabelMultiplier: CGFloat = 0.20
        static let topMarginTextFieldMultiplier: CGFloat = 0.01
        static let leadingTrailingMarginTextFieldMultiplier: CGFloat = 0.15
        static let heightMarginTextFieldMultiplier: CGFloat = 0.07
        static let topMarginButtonMultiplier: CGFloat = 0.1
        static let leadingTrailingMarginButtonMultiplier: CGFloat = 0.25
        static let heightMarginButtonMultiplier: CGFloat = 0.07
        static let cornerRadiusTextFieldMultiplier: CGFloat = 0.035
        static let cornerRadiusButtonMultiplier: CGFloat = 0.035
        static let indentTextFieldForMultiplier: CGFloat = 0.05
    }

    private enum ColorPalette {
        static let gradientStartColor = UIColor.systemPurple
        static let gradientEndColor = UIColor.systemCyan
        static let defaultTitleLable = UIColor.white
        static let buttonBackground = UIColor.white
        static let buttonTitle = UIColor.systemGray
        static let textField = UIColor.black
        static let textLabelAboveTextField = UIColor.systemGray5
    }

    private enum FontSize {
        static let titleLabel: CGFloat = 24
        static let loginButton: CGFloat = 18
        static let labelAboveTextField: CGFloat = 12
    }
}
