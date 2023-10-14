import UIKit
import SnapKit

class TodoCell: UITableViewCell {
    static let reuseIdentifier = "TodoCell"
    var viewModel: TodoCellViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        observeTextChanges()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var checkbox = {
        let image = UIImage(systemName: "circle")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheckbox))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var textStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        return stackView
    }()

    private lazy var titleTextField = {
        let textField = UITextField()
        textField.delegate = self
        return textField
    }()

    private lazy var memoTextField = {
        let textField = UITextField()
        textField.placeholder = "메모 추가"
        textField.font = .systemFont(ofSize: 13)
        textField.delegate = self
        textField.textColor = .secondaryLabel
        return textField
    }()

    private func setupLayout() {
        contentView.addSubview(checkbox)
        checkbox.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(9)
            make.leading.equalToSuperview().inset(10)
            make.height.width.equalTo(25)
        }

        contentView.addSubview(textStackView)
        textStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.leading.equalTo(checkbox.snp.trailing).offset(7)
            make.trailing.equalToSuperview()
        }

        textStackView.addArrangedSubview(titleTextField)
        textStackView.addArrangedSubview(memoTextField)
    }

    func titleBecomeFirstResponder() {
        titleTextField.becomeFirstResponder()
    }

    private func observeTextChanges() {
        titleTextField.addTarget(self, action: #selector(titleDidChange(_:)), for: .editingChanged)
        memoTextField.addTarget(self, action: #selector(memoDidChange(_:)), for: .editingChanged)
    }

    @objc private func titleDidChange(_ textField: UITextField) {
        viewModel?.title = textField.text ?? ""
    }

    @objc private func memoDidChange(_ textField: UITextField) {
        viewModel?.memo = textField.text
    }

    func configure(with viewModel: TodoCellViewModel) {
        self.viewModel = viewModel
        titleTextField.text = viewModel.title
        memoTextField.text = viewModel.memo
        memoTextField.isHidden = viewModel.isMemoHidden
        configureCheckbox(isComplete: viewModel.isComplete)
    }

    private func toggleMemoTextFieldVisibility(_ isHidden: Bool) {
        if isHidden,
           let memo = viewModel?.memo,
           !memo.isEmpty {
            setMemoTextFieldIsHidden(false)
            return
        }
        
        setMemoTextFieldIsHidden(true)
    }

    private func setMemoTextFieldIsHidden(_ value: Bool) {
        memoTextField.isHidden = value
        UIView.performWithoutAnimation {
            invalidateIntrinsicContentSize()
        }
    }

    @objc private func toggleCheckbox() {
        viewModel?.isComplete.toggle()
        let isComplete = viewModel?.isComplete == true
        configureCheckbox(isComplete: isComplete)
    }

    private func configureCheckbox(isComplete: Bool) {
        checkbox.image = UIImage(systemName: isComplete ? "circle.inset.filled" : "circle")
        titleTextField.textColor = isComplete ? .secondaryLabel : .label
    }
}

extension TodoCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let viewModel else { return }

        if textField == memoTextField, titleTextField.text?.isEmpty == true {
            let newTodoTitle = "새로운 미리 알림"
            titleTextField.text = newTodoTitle
            viewModel.title = newTodoTitle
        }
        setMemoTextFieldIsHidden(false)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        Task {
            if textField == titleTextField {
                viewModel?.endEditingTitle(with: textField.text)
            }
        }
        toggleMemoTextFieldVisibility(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField == titleTextField else { return true }

        if textField.text?.isEmpty == false {
            viewModel?.addNewTodoItem()
            return false
        } else {
            textField.resignFirstResponder()
            return false
        }
    }
}
