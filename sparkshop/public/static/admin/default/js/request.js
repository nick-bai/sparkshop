axios.interceptors.response.use(
    (response) => {
        // 拦截登录过期
        if (response.data.code == 403) {
            window.location.href = '/admin/login/index';
        }
        return response;
    },
    (error) => {
        if (error.response) {
            //notify.error()
            message.run(error.response.data.message || "Status:500，服务器发生错误！", "error", 5000);
            return false;
        }

        return Promise.reject(error.response);
    }
);

window.request = {

    /** get 请求
     * @param  {接口地址} url
     * @param  {请求参数} params
     * @param  {参数} config
     */
    get: function(url, params={}, config={}) {
        return new Promise((resolve, reject) => {
            axios({
                method: 'get',
                url: url,
                headers: {
                    "content-type": "application/json",
                    "x-requested-with": "XMLHttpRequest"
                },
                params: params,
                ...config
            }).then((response) => {
                resolve(response.data);
            }).catch((error) => {
                reject(error);
            })
        })
    },

    /** post 请求
     * @param  {接口地址} url
     * @param  {请求参数} data
     * @param  {参数} config
     */
    post: function(url, data={}, config={}) {
        return new Promise((resolve, reject) => {
            axios({
                method: 'post',
                url: url,
                headers: {
                    "content-type": "application/json",
                    "x-requested-with": "XMLHttpRequest"
                },
                data: data,
                ...config
            }).then((response) => {
                resolve(response.data);
            }).catch((error) => {
                reject(error);
            })
        })
    },

    /** put 请求
     * @param  {接口地址} url
     * @param  {请求参数} data
     * @param  {参数} config
     */
    put: function(url, data={}, config={}) {
        return new Promise((resolve, reject) => {
            axios({
                method: 'put',
                url: url,
                headers: {
                    "content-type": "application/json",
                    "x-requested-with": "XMLHttpRequest"
                },
                data: data,
                ...config
            }).then((response) => {
                resolve(response.data);
            }).catch((error) => {
                reject(error);
            })
        })
    },

    /** patch 请求
     * @param  {接口地址} url
     * @param  {请求参数} data
     * @param  {参数} config
     */
    patch: function(url, data={}, config={}) {
        return new Promise((resolve, reject) => {
            axios({
                method: 'patch',
                url: url,
                headers: {
                    "content-type": "application/json",
                    "x-requested-with": "XMLHttpRequest"
                },
                data: data,
                ...config
            }).then((response) => {
                resolve(response.data);
            }).catch((error) => {
                reject(error);
            })
        })
    },

    /** delete 请求
     * @param  {接口地址} url
     * @param  {请求参数} data
     * @param  {参数} config
     */
    delete: function(url, data={}, config={}) {
        return new Promise((resolve, reject) => {
            axios({
                method: 'delete',
                url: url,
                headers: {
                    "content-type": "application/json",
                    "x-requested-with": "XMLHttpRequest"
                },
                data: data,
                ...config
            }).then((response) => {
                resolve(response.data);
            }).catch((error) => {
                reject(error);
            })
        })
    },

    /** jsonp 请求
     * @param  {接口地址} url
     * @param  {JSONP回调函数名称} name
     */
    jsonp: function(url, name='jsonp'){
        return new Promise((resolve) => {
            var script = document.createElement('script')
            var _id = `jsonp${Math.ceil(Math.random() * 1000000)}`
            script.id = _id
            script.type = 'text/javascript'
            script.src = url
            window[name] =(response) => {
                resolve(response)
                document.getElementsByTagName('head')[0].removeChild(script)
                try {
                    delete window[name];
                }catch(e){
                    window[name] = undefined;
                }
            }
            document.getElementsByTagName('head')[0].appendChild(script)
        })
    }
}

const message = {
    background: '', // 背景颜色
    outside: '', // 外框元素
    inside: '', // 信息显示元素
    insideSetTime: '', // 信息移除setTime
    body: '', // body元素
    time: 0, // 显示时间
    run(msg = "success", type = 'success', time = 2000) {
        // 显示时间
        this.time = time;

        // 背景色
        this.background = this.backgroundCheck(type)

        // body
        this.body = document.body;

        // 时间戳id
        let id = 'inside_box' + Date.now();

        // 检查是否存在外框
        let outsideShow = document.getElementById('message_box_show');
        if (outsideShow != null) {
            // 文字显示区域
            this.inside = document.createElement('div');
            this.inside.setAttribute('class', 'message_box_inside cc-display')
            this.inside.setAttribute('id', id)
            this.inside.style.backgroundColor = this.background;
            this.inside.innerHTML = `<span>${msg}</span>`
            outsideShow.appendChild(this.inside);
        } else {
            // 最外框
            this.outside = document.createElement('div');
            this.outside.setAttribute('id', 'message_box_outside')
            this.outside.setAttribute('class', 'cc-display')

            // 中间区域
            outsideShow = document.createElement('div');
            outsideShow.setAttribute('id', 'message_box_show');

            // 文字显示区域
            this.inside = document.createElement('div');
            this.inside.setAttribute('class', 'message_box_inside cc-display')
            this.inside.setAttribute('id', id)
            this.inside.style.backgroundColor = this.background;
            this.inside.innerHTML = `<span>${msg}</span>`

            // 显示
            outsideShow.appendChild(this.inside);
            this.outside.appendChild(outsideShow);
            this.body.appendChild(this.outside);
        }

        // 添加监听
        this[id] = this.insideTime(this.inside, outsideShow);
        this.boxShowTime(this.inside, id, outsideShow);
    },

    // 信息显示区域展示
    boxShowTime(inside, insideSetTime, outsideShow) {
        inside.addEventListener('mouseleave', () => {
            // 离开后设置隐藏时间
            this[insideSetTime] = this.insideTime(inside, outsideShow);
        })
        inside.addEventListener('mouseenter', () => {
            // 清除隐藏设置
            clearTimeout(this[insideSetTime]);
        })
    },

    // 信息区显示
    insideTime(inside, outsideShow) {
        let insideSetTime = setTimeout(() => {
            outsideShow.removeChild(inside);
        }, this.time);
        return insideSetTime;
    },

    // 判定显示颜色
    backgroundCheck(type) {
        if (type === 'success') return '#67C23A';
        if (type === 'error') return '#f56c6c';
        if (type === 'warning') return '#E6A23C';
        // if (type === 'info') return '#909399';
        return '#909399'; // 默认级别
    },
}