/**
 * @file sequential.h
 * @date 2022-07-18 14:07:71
 * @author zhongziyang (hankknight@live.com)
 * @brief head file of sequential sampler
 *
 * @copyright Copyright (c) 2022
 *
 */
#pragma once

#include <map>
#include <string>
#include <torch/torch.h>

using namespace std;

class TSSequentialSampler : public torch::data::Dataset<TSSequentialSampler> {
public:
    TSSequentialSampler(const map<string, torch::Tensor>& data,
                        int64_t step_len,
                        const map<string, vector<string>>& meta_info,
                        const string& fill_type = "none"
                        /* add your addition parameters */);
    ~TSSequentialSampler();

    /* ************************************************************************
     * torch::data::Example<> means you need to return two tensor data and target
     * you should write return like this:
     * return {Tensor(), Tensor()}
     * ***********************************************************************/

    // get sample via index
    torch::data::Example<> get(size_t index) override;

    // get sample via datetime and company
    torch::data::Example<> get(const string& date, const string& company);

    // total sample length
    torch::optional<size_t> size() const override;
};
